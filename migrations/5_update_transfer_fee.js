
const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const PREToken = artifacts.require('PREToken');
const PRETokenV4 = artifacts.require('PRETokenV4');

module.exports = async function (deployer) {
  const existing = await PREToken.deployed();
  const instance = await upgradeProxy(existing.address, PRETokenV4, { deployer,  initializer: "initialize", unsafeAllowCustomTypes: true });
  console.log("Upgraded", instance.address);
};
