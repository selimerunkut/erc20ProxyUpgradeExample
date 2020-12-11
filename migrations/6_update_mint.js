
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const PREToken = artifacts.require('PREToken');
const PRETokenV5 = artifacts.require('PRETokenV5');

module.exports = async function (deployer) {
  const existing = await PREToken.deployed();
  const instance = await upgradeProxy(existing.address, PRETokenV5, { deployer,  initializer: "initialize", unsafeAllowCustomTypes: true });
  console.log("Upgraded", instance.address);
};
