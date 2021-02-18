// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "./IOracle.sol";

contract LgmOracleConsumer {
    IOracle public oracle;
    uint256 public oracleData;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function fetchData() external {
        bytes32 key = keccak256(abi.encodePacked("BTC/USD"));
        (bool result, uint256 timestamp, uint256 data) = oracle.getData(key);
        require(result == true, "no data from oracle");
        require(timestamp >= block.timestamp - 2 minutes, "data is too old");
        oracleData = data;
    }
}
