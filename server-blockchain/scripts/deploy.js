const hre = require("hardhat");

async function main() {
  const SuperNFT = await hre.ethers.getContractFactory("SuperNFT");
  const superNft = await SuperNFT.deploy("SuperNFT", "SFT");

  await superNft.deployed();
  console.log("Successfully deployed smart contract to: ", superNft.address);

  await superNft.mint("https://ipfs.io/ipfs/QmYGJpUV7xLJrYAJQyKxw6LXzCWU3LoP3QLfyJA55Pa9NL");
  console.log("NFT successfully minted");
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });