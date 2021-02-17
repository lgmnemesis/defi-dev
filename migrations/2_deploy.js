const LgmToken = artifacts.require("LgmToken");
const ContractA = artifacts.require("ContractA");
const LgmNFT = artifacts.require("LgmNFT");
const LgmWeth = artifacts.require("LgmWeth");
const LgmOracle = artifacts.require("LgmOracle");
const LgmOracleConsumer = artifacts.require("LgmOracleConsumer");

module.exports = async function (deployer, _network, addresses) {
  [admin, collateralContract, reporter, _] = addresses;

  await deployer.deploy(LgmToken, 'Lgm Token', 'LGM');
  const lgmToken = await LgmToken.deployed();
  deployer.deploy(ContractA, lgmToken.address);

  deployer.deploy(LgmNFT, 'Lgm NFT', 'LNF');

  deployer.deploy(LgmWeth, 'Lgm Weth', 'Leth');

  await deployer.deploy(LgmOracle, admin);
  const lgmOracle = await LgmOracle.deployed();
  lgmOracle.updateReporter(reporter, true);
  deployer.deploy(LgmOracleConsumer, lgmOracle.address);

};
