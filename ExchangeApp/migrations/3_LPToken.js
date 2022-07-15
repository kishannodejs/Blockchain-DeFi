const LPToken = artifacts.require("LPT");

module.exports = function (deployer) {
  deployer.deploy(LPToken, "Liquidity Pool Token", "LPT");
};
