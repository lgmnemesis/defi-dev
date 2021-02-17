const Coingecko = require('coingecko-api');
const Oracle = artifacts.require('LgmOracle.sol');

const POLL_INTERVAL = 5000;
const coingeckoClient = new Coingecko();

module.exports = async done => {
  try {
    const [_a, _b, reporter] = await web3.eth.getAccounts();
    const oracle = await Oracle.deployed();
    while(true) {
      const response = await coingeckoClient.coins.fetch('bitcoin', {});
      let currentPrice = parseFloat(response.data.market_data.current_price.usd);
      currentPrice = parseInt(currentPrice * 100);
      await oracle.updateData(
        web3.utils.soliditySha3('BTC/USD'),
        currentPrice,
        {from: reporter}
      );
      console.log(`New price for BTC/USD ${currentPrice} updated on-chain`);
      await new Promise(resolve => setTimeout(resolve, POLL_INTERVAL));
    }
    // done(); 
  } catch (error) {
    console.error(error);
  }
}
