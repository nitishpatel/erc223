require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("hardhat-deploy");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
MNEMONIC = process.env.MNEMONIC;

module.exports = {
  solidity: "0.8.17",
  namedAccounts: {
    deployer: 0,
    account1: 1,
  },
  networks:{
    apothem:{
      url: "https://erpc.apothem.network",
      accounts: {mnemonic: MNEMONIC},
    }
  }
};
