// server.js

const express = require('express');
const { createAlchemyWeb3 } = require('@alch/alchemy-web3'); // Use AlchemyWeb3 for Node.js
const axios = require('axios');

const app = express();
const port = 3000;

// Connect to your Alchemy or local Ethereum node
const web3 = createAlchemyWeb3('http://localhost:7545'); // Update with your Ethereum node URL
const contractAddress = '0xYourContractAddress'; // Update with your deployed contract address
const contractABI = require('./build/contracts/LockableNFT.json').abi;
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Define API routes
app.get('/api/isTokenLocked/:tokenId', async (req, res) => {
  const tokenId = req.params.tokenId;
  const isLocked = await contract.methods.isTokenLocked(tokenId).call();
  res.json({ isLocked });
});

// Add more routes for other contract functions...

// Start the server
app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
