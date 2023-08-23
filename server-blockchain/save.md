const Web3 = require("web3");
const ethers = require("ethers");
const { Alchemy, Network, Wallet, Utils } = require("alchemy-sdk");

const settings = {
  apiKey: "7u9ag44gEfuJtfihRfFlgTU4UMEV02HV",
  network: Network.ETH_GOERLI,
};

const contractAddress = "0x404f79c45D27512D05C1EBfdBA6FF4B3Ffc6b6e5";
const alchemyUrl =
  "https://eth-goerli.g.alchemy.com/v2/7u9ag44gEfuJtfihRfFlgTU4UMEV02HV"; // Replace with your Alchemy API key
const fs = require("fs");

const contractJson = fs.readFileSync(
  "./build/artifacts/contracts/TrophiesCard.sol/TrophiesCard.json",
  "utf8"
);

// Chuyển đổi nội dung từ JSON thành đối tượng JavaScript
const contractData = JSON.parse(contractJson);

const contractAbi = contractData.abi;

const init = async () => {
  const privateKey =
    "dea7d2820b27c8ea5e7c9e54ca2a6365607373649e9de92752d8cf844559b5ad"; // Replace with your private key

  const alchemy = new Alchemy(settings);

  let wallet = new Wallet(privateKey);

//   const web3 = new Web3(alchemyUrl);
  const account = web3.eth.accounts.privateKeyToAccount(privateKey);

  const contract = new alchemy.web3.eth.Contract(contractAbi, contractAddress);

  const name = await contract.methods.name().call();
  const symbol = await contract.methods.symbol().call();
  console.log("Name: ", name);
  console.log("Symbol: ", symbol);

  const requestNFT = async () => {
    const gasPrice = await web3.eth.getGasPrice();
    const nonce = await alchemy.web3.eth.getTransactionCount(
      wallet.address,
      "latest"
    );

    const txData = contract.methods.someMethod().encodeABI();

    const tx = await contract.methods.requestNFT().send({
      from: account.address,
      gasPrice: gasPrice,
      nonce: nonce,
      value: Utils.parseEther("0.02"),
      data: contract.methods.requestNFT().encodeABI(),
    });

    const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);

    const result = await web3.eth.sendSignedTransaction(
      signedTx.rawTransaction
    );
    console.log("Transaction hash:", result.transactionHash);
  };

  requestNFT();
};

init();
