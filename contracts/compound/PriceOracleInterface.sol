// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

interface PriceOracleInterface {
    function getUnderlyingPrice(address asset) external view returns (uint256);
}
