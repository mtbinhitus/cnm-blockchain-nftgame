const API_KEY = "7u9ag44gEfuJtfihRfFlgTU4UMEV02HV";
const PRIVATE_KEY =
  "dea7d2820b27c8ea5e7c9e54ca2a6365607373649e9de92752d8cf844559b5ad";
const CONTRACT_ADDRESS = "0x404f79c45D27512D05C1EBfdBA6FF4B3Ffc6b6e5";
const API_URL =
  "https://eth-goerli.g.alchemy.com/v2/7u9ag44gEfuJtfihRfFlgTU4UMEV02HV";
const ACCOUNT_ADDRESS = "0xA6fae02810B4CCA54d7D3219c4878905A5FFdC22";



const fs = require("fs");

const contractJson = fs.readFileSync(
  "./build/artifacts/contracts/TrophiesCard.sol/TrophiesCard.json",
  "utf8"
);

const contractData = JSON.parse(contractJson);

const contractAbi = contractData.abi;


const Web3 = require("web3");
const web3 = new Web3(API_URL);

const contract = new web3.eth.Contract(contractAbi, CONTRACT_ADDRESS);

const main = async () => {
  const gasPrice = await web3.eth.getGasPrice();
  const nonce = await web3.eth.getTransactionCount(ACCOUNT_ADDRESS);

  const txObject = {
    from: ACCOUNT_ADDRESS,
    to: CONTRACT_ADDRESS,
    gas: 210000, // Số gas bạn muốn sử dụng
    gasPrice: gasPrice,
    nonce: nonce,
    data: contract.methods.requestNFT().encodeABI(), // Gọi hàm requestNFT()
    value: web3.utils.toWei("0.02", "ether"), // Số lượng Ether bạn muốn gửi
  };

  // Ký giao dịch với private key
  const signedTx = await web3.eth.accounts.signTransaction(
    txObject,
    PRIVATE_KEY
  );

  // Gửi giao dịch đã ký
  const txReceipt = await web3.eth.sendSignedTransaction(
    signedTx.rawTransaction
  );

  console.log("Transaction receipt:", txReceipt);
};

main();
// .then(() => process.exit(0)).catch(err => {
//     console.log(err)
// })
