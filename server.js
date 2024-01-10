// server.js

const express = require('express');
const { createAlchemyWeb3 } = require('@alch/alchemy-web3'); // Use AlchemyWeb3 for Node.js
const axios = require('axios');

const app = express();
const port = 3000;

// Connect to the Sepolia testnet
const web3 = createAlchemyWeb3('https://eth-rpc.ankr.com/'); // Update with Sepolia testnet node URL
const contractAddress = '0xd9145CCE52D386f254917e481eB44e9943F39138'; // Update with your deployed contract address on Sepolia
const contractABI = require('./build/contracts/LockableNFT.json').abi;
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Define API routes
app.get('/api/isTokenLocked/:tokenId', async (req, res) => {
  const tokenId = req.params.tokenId;
  const isLocked = await contract.methods.isTokenLocked(tokenId).call();
  res.json({ isLocked });
});

//More contracts can be added here

// Start the server
app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
