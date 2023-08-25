const fs = require("fs");

const path = require("path");
const Web3 = require("web3");

const PRIVATE_KEY =
  "dea7d2820b27c8ea5e7c9e54ca2a6365607373649e9de92752d8cf844559b5ad";

const CONTRACT_ADDRESS = "0x404f79c45D27512D05C1EBfdBA6FF4B3Ffc6b6e5";

const API_URL =
  "https://eth-goerli.g.alchemy.com/v2/7u9ag44gEfuJtfihRfFlgTU4UMEV02HV";

const ACCOUNT_ADDRESS = "0xA6fae02810B4CCA54d7D3219c4878905A5FFdC22";

const filePath = path.join(
  __dirname,
  `../build/artifacts/contracts/TrophiesCard.sol/TrophiesCard.json`
);

const contractJson = fs.readFileSync(filePath, "utf8");

const contractData = JSON.parse(contractJson);

const contractAbi = contractData.abi;

const web3 = new Web3(API_URL);

const contract = new web3.eth.Contract(contractAbi, CONTRACT_ADDRESS);

// const sendNFT = async (address_to) => {};

// senNFT(1, "0x33739B1802B981D04c2c6BcD1637963438dc057E");

function convertIpfsUrl(ipfsUrl) {
  const ipfsHash = ipfsUrl.split("ipfs://")[1];
  if (!ipfsHash) {
    return null; // Không phải định dạng ipfs:// hợp lệ
  }
  const convertedUrl = `https://ipfs.io/ipfs/${ipfsHash}`;
  return convertedUrl;
}

const nftController = {
  transferNFT: async (req, res) => {
    try {
      const gasPrice = await web3.eth.getGasPrice();
      const nonce = await web3.eth.getTransactionCount(ACCOUNT_ADDRESS);
      const address_to = req.body.address_to;
      const tokenIdNext = await contract.methods.getTokenCounter().call();

      const txObject = {
        from: ACCOUNT_ADDRESS,
        to: CONTRACT_ADDRESS,
        gas: 210000, // Số gas bạn muốn sử dụng
        gasPrice: gasPrice,
        nonce: nonce,
        data: contract.methods
          .transferFrom(ACCOUNT_ADDRESS, address_to, tokenIdNext - 1)
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

      res.status(200).json({
        message: "transfer successfully",
      });
    } catch (error) {
      res.send(error);
    }
  },
  createNFT: async (req, res) => {
    try {
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

      res.status(200).json({
        message: "create NFT successfully",
      });
    } catch (error) {
      res.send(error);
    }
  },

  getNftInfo: async (req, res) => {
    const tokenIdNext = await contract.methods.getTokenCounter().call();
    const trophiesCardData = await contract.methods
      .tokenURI(tokenIdNext-1)
      .call();
    const x = convertIpfsUrl(trophiesCardData);

    res.status(200).json({
      message: "create NFT successfully",
      trophiesCardData: x,
    });
  },

  test: async (req, res) => {
    try {
      const id = req.body.address_to;

      console.log("Count: ", count);

      res.status(200).json({
        message: "ok",
        count: count,
        id: id,
      });
    } catch (error) {
      res.send(error);
    }
  },
};

module.exports = nftController;
