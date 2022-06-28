
/**
 * @type import('Hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-ethers");
require('dotenv').config();


const privateKey = process.env.PRIVATE_KEY;
module.exports = {
  defaultNetwork: "localhost",
  solidity: "0.8.13",
  networks: {
    localhost: {
      chainId: 31337,
    },
    galileo: {
      url: "https://galileo.web3q.io:8545",
      accounts: [privateKey],
      chainId: 3334,
      gasPrice: 10000000000,
    },
  }
};
