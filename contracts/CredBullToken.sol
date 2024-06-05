// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CredBullToken is ERC20 {
    constructor(uint256 totalSupply) ERC20("CredBull Token", "CBT") {
        _mint(msg.sender, totalSupply);
    }
}
