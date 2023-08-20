require("@nomiclabs/hardhat-ethers");
const privateKey = "7ec01c607f81cc3cef214a870cde5b5417cd63e3d9612814b3aadf10c1882919";
module.exports = {
  defaultNetwork: "matic",
  networks: {
    hardhat: {
    },
    matic: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [privateKey]
    }
  },
  solidity: {
    version: "0.8.2",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}