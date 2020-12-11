
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const PREToken = artifacts.require('PREToken');
const PRETokenV3 = artifacts.require('PRETokenV3');

module.exports = async function (deployer) {
  const existing = await PREToken.deployed();
  const instance = await upgradeProxy(existing.address, PRETokenV3, { deployer,  initializer: "initialize", unsafeAllowCustomTypes: true });
  console.log("Upgraded", instance.address);
};
