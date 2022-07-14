const DEXRouter = artifacts.require("DEXRouter");

module.exports = function (deployer) {
  deployer.deploy(DEXRouter);
};
