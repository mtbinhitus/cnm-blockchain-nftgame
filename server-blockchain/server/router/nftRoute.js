const nftController = require("../controller/nftController");

const router = require("express").Router();

router.post("/mint", nftController.createNFT);

router.post("/transfer", nftController.transferNFT);

router.get("/info", nftController.getNftInfo);

router.post("/update-score", nftController.updateScore);

module.exports = router;
