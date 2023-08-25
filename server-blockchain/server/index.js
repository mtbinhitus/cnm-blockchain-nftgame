const express = require("express");
const app = express();
const cors = require("cors");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const dotenv = require("dotenv");
app.use(bodyParser.urlencoded({ extended: true }));

const nftRoute = require("./router/nftRoute")
dotenv.config();


app.use(morgan("common"));
app.use(cors());

app.use(express.json());


app.get("/", (req, res) => {
  res.send("this is blockchain project");
});


app.use("/api/nft", nftRoute)


app.listen( 8000, () => {
  console.log(`Example app listening on port`);
});
