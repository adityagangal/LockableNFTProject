module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545, // Update with your Ethereum node port (Ganache default is 7545)
      network_id: "*", // Match any network id
    },
  },
  compilers: {
    solc: {
      version: "^0.8.19", // Use the Solidity version specified in your contract
    },
  },
};
