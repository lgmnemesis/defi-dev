// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

interface ComptrollerInterface {
    function enterMarkets(address[] calldata cTokens)
        external
        returns (uint256[] memory);

    function getAccountLiquidity(address owner)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        );
}
