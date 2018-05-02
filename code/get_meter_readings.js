#!/usr/bin/env node
const Web3 = require('web3')
const args = require('optimist').string("address").argv;
const truffleContract = require("truffle-contract");
const web3 = new Web3(new Web3.providers.HttpProvider(args.rpc));

function toAscii(input) {
    return web3.toAscii(input).replace(/\u0000/g, '');
}

let conf;
if (args.abi) {
    conf = require(args.abi);
} else {
    conf = require('./conf/abi/MeterDB.json');
}

let address = args.address;
let abi = conf.abi;

const contract = truffleContract({ abi });
contract.setProvider(web3.currentProvider);
meterdb = contract.at(address);

let meters = {}
if (args.meter) {
    meters = { "meterId": args.meter.split(" ") };
}

meterdb.Pinged(meters, { fromBlock: 0, toBlock: 'latest' }).get((err, res) => {
    if (!err) {
        res.forEach(log => {
            // event Pinged(address indexed meterAddress, bytes8 indexed meterId, uint80 power, uint80 timestamp);
            arg = log.args;
            meterId = arg.meterId;
            power = arg.power;
            timestamp = arg.timestamp;
            console.log('Meter ' + toAscii(meterId) + ': ' + power + ' kWh at ' + timestamp);
        });
    }
});
