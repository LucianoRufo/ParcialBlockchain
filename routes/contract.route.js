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

router.get("/deploy", function (req, res) {
  try {
    contractService.deploy();
    res.status(200).send("Contract deployed");
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/configureContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    let result = await contract.methods
      .configureContract(req.body.data)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Contract configured successfully. ");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/getBalanceInmobiliaria", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    let result = await contract.methods
      .getBalance()
      .call({ from: sender })
      .then(function (result) {
        res.status(200).send("Balance Inmobiliaria: " + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/getClientBalance", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    let result = await contract.methods
      .getClientBalance(req.body.client)
      .call({ from: sender })
      .then(function (result) {
        res.status(200).send("Client balance: " + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/retireFundsInmobiliaria", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    let result = await contract.methods
      .retireFunds(req.body.amount)
      .send({
        gas: "6721975",
        from: sender,
        value: 0, // web3.utils.toWei('10', 'ether')
      })
      .then(function (result) {
        res.status(200).send("Contract configured successfully. ");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/getMyContractAddress", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    let result = await contract.methods
      .getMyContractAddress()
      .call({ from: sender })
      .then(function (result) {
        res.status(200).send("Client balance: " + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/getMyContractBalance", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    let result = await contract.methods
      .getMyBalance()
      .call({ from: sender })
      .then(function (result) {
        res.status(200).send("Client balance: " + result);
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/joinByDeposit", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    const receiver = req.body.inmobiliariaContractAddress;

    web3.eth.sendTransaction({
      to: receiver,
      from: sender,
      value: web3.utils.toWei(req.body.amount.toString(), "ether"),
    });

    res
      .status(200)
      .send("Made contribution and joined as a client successfully!");
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/depositToMyContract", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;
    const receiver = req.body.myContractAddress;

    web3.eth.sendTransaction({
      to: receiver,
      from: sender,
      value: web3.utils.toWei(req.body.amount.toString(), "ether"),
    });

    res.status(200).send("Deposited succesfully!");
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

router.post("/withdrawAndClose", async function (req, res) {
  try {
    const contract = contractService.getContract(contractName);
    const sender = req.body.sender;

    let result = await contract.methods
      .destroyClientContract()
      .call({ from: sender })
      .then(function (result) {
        res.status(200).send("Withdrew and deleted with sucess");
      });
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
});

module.exports = router;
