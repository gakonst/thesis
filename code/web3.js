node
    > Web3 = require('web3');
> INFURA_API = process.env.INFURA_API; // Infura is a third party service that allows us to connect to their Ethereum node without setting up our own. > web3 = new Web3(new Web3.providers.HttpProvider("https://mainnet.infura.io/" + INFURA_API));
> web3.eth.blockNumber;
5289236


