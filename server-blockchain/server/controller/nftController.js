const fs = require("fs");

const path = require("path");
const Web3 = require("web3");

const PRIVATE_KEY =
  "b6c1dc049bde4d0015332ad02ef4cee0d9bff31bccd91ac0d42543a79e2b029e";

const CONTRACT_ADDRESS = "0x404f79c45D27512D05C1EBfdBA6FF4B3Ffc6b6e5";

const API_URL =
  "https://eth-goerli.g.alchemy.com/v2/7u9ag44gEfuJtfihRfFlgTU4UMEV02HV";

const ACCOUNT_ADDRESS = "0x87832Ac75e086bb8A4E4fcc513D156F529C98E2B";

const filePath = path.join(
  __dirname,
  `../build/artifacts/contracts/PepeCard.sol/PepeCard.json`
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

function writeData(data, address) {
  const filePath = path.join(__dirname, "../public/history.json");
  fs.readFile(filePath, "utf8", (err, fileData) => {
    if (err) {
      console.error("Error reading JSON file:", err);
      return;
    }

    let jsonData = [];
    try {
      jsonData = JSON.parse(fileData);
    } catch (parseError) {
      console.error("Error parsing JSON:", parseError);
      return;
    }

    jsonData.unshift({ data, address });

    fs.writeFile(
      filePath,
      JSON.stringify(jsonData, null, 2),
      "utf8",
      (writeErr) => {
        if (writeErr) {
          console.error("Error writing to JSON file:", writeErr);
        } else {
          console.log("Data has been written to JSON file.");
        }
      }
    );
  });
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

      // lấy thông tin NFT:
      const pepeCardData = await contract.methods
        .tokenURI(tokenIdNext - 1)
        .call();
      const x = convertIpfsUrl(pepeCardData);

      // ghi lịch sử vào Data
      writeData(x, address_to);

      console.log("Transaction receipt sendNFT:", txReceipt);

      res.status(200).json({
        message: "transfer successfully",
      });
    } catch (error) {
      res.status(500).json({
        error: error.message,
      });
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
      res.status(500).json({
        error: error.message,
      });
    }
  },

  getNftInfo: async (req, res) => {
    const tokenIdNext = await contract.methods.getTokenCounter().call();
    const pepeCardData = await contract.methods
      .tokenURI(tokenIdNext - 1)
      .call();
    const x = convertIpfsUrl(pepeCardData);

    // writeData(x)

    res.status(200).json({
      message: "create NFT successfully",
      pepeCardData: x,
    });
  },

  updateScore: async (req, res) => {
    try {
      const score = req.body.score;
      const address = req.body.address;
      const filePath = path.join(__dirname, "../public/auth.json")
  
      // Read the JSON data from the file
      const authJson = fs.readFileSync(filePath, 'utf8');
      const authData = JSON.parse(authJson);
  
      let found = false;
  
      // Update the score if address already exists
      const updatedData = authData.map(item => {
        if (item.address == address) {
          found = true;
          return { ...item, score: score };
        }
        return item;
      });
  
      // Create a new object if address doesn't exist
      if (!found) {
        updatedData.push({ address: address, score: score });
      }
  
      // Write the updated data back to the file
      fs.writeFileSync(filePath, JSON.stringify(updatedData, null, 2), 'utf8');
  
      res.status(200).json({
        message: 'Score updated successfully',
      });
    } catch (error) {
      res.status(500).json({
        error: error.message,
      });
    }
  },


};

module.exports = nftController;
