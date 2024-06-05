// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CredBullVault is ERC4626, Ownable {
    IERC20 public immutable _asset;
    uint256 public minDepositAmount;
    uint256 public maxTotalAmount;
    uint256 public feePercentage;

    uint256 public totalDeposits;
    mapping(address => uint256) public deposits;
    mapping(address => bool) public whitelist;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event Whitelist(address indexed _address, bool value);

    constructor(
        IERC20 asset,
        uint256 _minDepositAmount,
        uint256 _maxTotalAmount,
        uint256 _feePercentage
    ) ERC20("CredBullVaultToken", "CBVT") ERC4626(asset) {
        _asset = asset;
        minDepositAmount = _minDepositAmount;
        maxTotalAmount = _maxTotalAmount;
        feePercentage = _feePercentage;
    }

    function addToWhitelist(address _address) external onlyOwner {
        whitelist[_address] = true;
        emit Whitelist(_address, true);
    }

    function removeFromWhitelist(address _address) external onlyOwner {
        whitelist[_address] = false;
        emit Whitelist(_address, false);
    }

    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        require(whitelist[msg.sender], "Address not whitelisted");
        require(assets >= minDepositAmount, "Deposit amount is less than minimum");
        require(totalAssets() + assets <= maxTotalAmount, "Total amount exceeds maximum");

        uint256 fee = (assets * feePercentage) / 100;
        uint256 netAssets = assets - fee;

        SafeERC20.safeTransferFrom(_asset, msg.sender, address(this), fee);

        deposits[receiver] += netAssets;
        totalDeposits += netAssets;
        emit Deposit(receiver, netAssets);

        _mint(receiver, netAssets);

        return super.deposit(netAssets, receiver);
    }

    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        require(whitelist[msg.sender], "Address not whitelisted");
        require(deposits[owner] >= assets, "Insufficient balance");

        uint256 excessBalance = totalAssets() - totalDeposits;
        uint256 proportion = (assets * 1e18) / totalDeposits;
        uint256 yield = (excessBalance * proportion) / 1e18;

        uint256 totalWithdrawal = assets + yield;

        deposits[owner] -= assets;
        totalDeposits -= assets;
        emit Withdrawal(receiver, totalWithdrawal);

        _burn(owner, assets);

        _asset.transfer(receiver, yield);
        return super.withdraw(assets, receiver, owner);
    }

    function totalAssets() public view override returns(uint256) {
        return _asset.balanceOf(address(this));
    }
}
