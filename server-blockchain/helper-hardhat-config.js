const networkConfig = {
    5: {
      name: 'goerli',
      vrfCoordinatorV2: '0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D',
      keyHash:
        '0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15',
      callbackGasLimit: '500000', // 500,000 gas
      mintFee: '20000000000000000', // 0.02 ETH
      subscriptionId: '13727', // add your subscription ID here!
    },
  }
  
  const developmentChains = ['hardhat', 'localhost']
  
  module.exports = {
    networkConfig,
    developmentChains,
  }