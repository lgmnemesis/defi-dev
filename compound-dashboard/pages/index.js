import Head from 'next/head'
import Compound from '@compound-finance/compound-js'
import calculateApy from '../apy'

export default function Home( {apys}) {
  const formatPercent = number => {
    return `${new Number(number).toFixed(2)}%`
  }

  return (
    <div className="container">
      <Head>
        <title>Compound Dashboard</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <div className='row mt-4'>
        <div className='col-sm-12'>
          <div className="jumbotron">
            <h1 className='text-center'>Compound Dashboard</h1>
            <h5 className="display-4 text-center">
              Shows Compound APYs <br/> with COMP token rewards
            </h5>
          </div>
        </div>
      </div>

      <table className="table">
        <thead>
          <tr>
            <th>Ticker</th>
            <th>Supply APY</th>
            <th>COMP APY</th>
            <th>Total APY</th>
          </tr>
        </thead>
        <tbody>
          {apys && apys.map((token) => {
            return (
              <tr key={token.ticker}>
                <td>
                  <img src={`img/${token.ticker.toLowerCase()}.png`} style={{width: 25, height: 25, marginRight: 10}}/>
                  {token.ticker.toUpperCase()}
                </td>
                <td>{formatPercent(token.supplyApy)}</td>
                <td>{formatPercent(token.compApy)}</td>
                <td>{formatPercent(parseFloat(token.supplyApy) + parseFloat(token.compApy))}</td>
              </tr>
              )
          })}
        </tbody>
      </table>
    </div>
  )
}

export async function getServerSideProps(context) {
  const apys = await Promise.all([
    calculateApy(Compound.cDAI, 'DAI'),
    calculateApy(Compound.cUSDC, 'USDC'),
    calculateApy(Compound.cUSDT, 'USDT')
  ]);
  return {
    props: {
      apys
    }
  }
}
