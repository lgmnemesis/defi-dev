const LgmToken = artifacts.require("LgmToken");

module.exports = function (deployer) {
  deployer.deploy(LgmToken, 'Lgm Token', 'LGM');
};
