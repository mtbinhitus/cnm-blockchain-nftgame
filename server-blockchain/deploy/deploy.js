const { network, ethers } = require('hardhat')
const { verify } = require('../verify')
const { developmentChains, networkConfig } = require('../helper-hardhat-config')

module.exports = async function({ getNamedAccounts, deployments }) {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()

  const chainId = network.config.chainId

  let mintFee,
    subscriptionId,
    vrfCoordinatorV2Address,
    keyHash,
    callbackGasLimit

  if (!developmentChains.includes(network.name)) {
    mintFee = networkConfig[chainId].mintFee
    subscriptionId = networkConfig[chainId].subscriptionId
    vrfCoordinatorV2Address = networkConfig[chainId].vrfCoordinatorV2
    keyHash = networkConfig[chainId].keyHash
    callbackGasLimit = networkConfig[chainId].callbackGasLimit
  }

  const args = [
    mintFee,
    vrfCoordinatorV2Address,
    subscriptionId,
    keyHash,
    callbackGasLimit,
  ]

  log('Deploying...')
  const pepeCard = await deploy('PepeCards', {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  })

  // Verify contract
  if (
    !developmentChains.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    log('Verifying...')
    await verify(pepeCard.address, args)
  }
}
