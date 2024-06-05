// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const assetAddress = "0xE5a25C884834abC78B031DdAdc169481E0D06173";
  const minDepositAmount = hre.ethers.parseUnits("1", 18);
  const maxTotalAmount = hre.ethers.parseUnits("1000", 18);
  const feePercentage = 1;
  await hre.run("verify:verify", {
    address: "0x09a49ed78643439531B1D344EdEa5FfDD92cA6eF",
    constructorArguments: [
      assetAddress,
      minDepositAmount,
      maxTotalAmount,
      feePercentage,
    ],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
