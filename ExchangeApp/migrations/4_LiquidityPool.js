const LiquidityPool = artifacts.require("LiquidityPool");

module.exports = function (deployer) {
  deployer.deploy(LiquidityPool);
};
