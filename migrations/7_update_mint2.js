
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const PREToken = artifacts.require('PREToken');
const PRETokenV6 = artifacts.require('PRETokenV6');

module.exports = async function (deployer) {
  const existing = await PREToken.deployed();
  const instance = await upgradeProxy(existing.address, PRETokenV6, { deployer,  initializer: "initialize", unsafeAllowCustomTypes: true });
  console.log("Upgraded", instance.address);
};
