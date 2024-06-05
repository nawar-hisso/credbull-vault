require("@nomicfoundation/hardhat-toolbox");
require("hardhat-contract-sizer");
require("dotenv").config();
require("./tasks/balance");

const { PRIVATE_KEY, ARCHIVAL_RPC, ETHEREUM_API_KEY, REPORT_GAS } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 10000,
      },
    },
  },
  networks: {
    sepolia: {
      url: `${ARCHIVAL_RPC}`,
      accounts: [
        `${
          PRIVATE_KEY ||
          "0x0000000000000000000000000000000000000000000000000000000000000000"
        }`,
      ],
    },
  },
  gasReporter: {
    enabled: REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: `${ETHEREUM_API_KEY}`,
  },
};
