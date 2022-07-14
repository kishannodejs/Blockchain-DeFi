const LPToken = artifacts.require("LPToken");

module.exports = function (deployer) {
  deployer.deploy(LPToken, "Liquidity Pool Token", "LPT");
};
