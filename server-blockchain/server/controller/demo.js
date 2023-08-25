const fs = require("fs");
require("dotenv").config();
const path = require("path");

const Web3 = require("web3");

// const { readTokenId, writeTokenId } = require("../helper/tokenId");

const PRIVATE_KEY = process.env.PRIVATE_KEY;

const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

const API_URL = process.env.API_URL;

const ACCOUNT_ADDRESS = process.env.ACCOUNT_ADDRESS;

const filePath = path.join(__dirname, `../build/artifacts/contracts/TrophiesCard.sol/TrophiesCard.json`)

const contractJson = fs.readFileSync(filePath, "utf8");

const contractData = JSON.parse(contractJson);

const contractAbi = contractData.abi;

const web3 = new Web3(API_URL);

const contract = new web3.eth.Contract(contractAbi, CONTRACT_ADDRESS);



const send = async () => {
    const gasPrice = await web3.eth.getGasPrice();
    const nonce = await web3.eth.getTransactionCount(ACCOUNT_ADDRESS);
  
    // const countToken = readTokenId();
  
    const txObject = {
      from: ACCOUNT_ADDRESS,
      to: CONTRACT_ADDRESS,
      gas: 210000, // Số gas bạn muốn sử dụng
      gasPrice: gasPrice,
      nonce: nonce,
      data: contract.methods
        .transferFrom(ACCOUNT_ADDRESS, address_to, countToken)
        .encodeABI(), // Gọi hàm transferFrom() để chuyển NFT
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
  
    console.log("Transaction receipt sendNFT:", txReceipt);
}


const requestNFT = async() => {
    const gasPrice = await web3.eth.getGasPrice();
      const nonce = await web3.eth.getTransactionCount(ACCOUNT_ADDRESS);
      const token_id = readTokenId();
    //   const address_to = req.body.address_to;

      console.log("TOKEN ID: ", token_id);

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
}


requestNFT()