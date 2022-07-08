const NeoToken = artifacts.require("NeoToken");

module.exports = function (deployer) {
  deployer.deploy(NeoToken, "NeoToken", "NT", 100000);
};
