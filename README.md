erc20 upgrade proxy example

based on [PREToken](https://github.com/PresearchOfficial/PRE-Token)

## Setup
1. run `npm install`
2. run `truffle compile`

## Local Testing
1. run `truffle compile --all`
2. Start a local blockchain (such as Ganache) on port 8545
3. run `truffle migrate`

## Interacting with the Deployed Token
1. run `truffle console`
2. run `let pre = await PREToken.deployed()`
3. run any contract functions on the `pre` object:
    * `pre.transfer(addresses[1], 100)`
    * `pre.transferBatch([addresses[2],addresses[3]],[2000, 300000])`
    * `pre.totalSupply()`
    * ...
