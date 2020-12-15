const express = require("express");
const router = express.Router();
const contractService = require("../services/contract.service");
var Web3 = require("web3");
const contractName = "CuentaAhorro";

router.get("/compile", function (req, res) {
  try {
    contractService.compile();
    res.status(200).send("Contract compiled");
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

module.exports = router;
