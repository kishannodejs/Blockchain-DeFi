const NEO = artifacts.require("ERC20");

module.exports = function (deployer) {
  deployer.deploy(NEO, "Neo", "NS" );
};
