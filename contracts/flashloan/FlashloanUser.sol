// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./FlashloanProvider.sol";
import "./IFlashloanUser.sol";

contract FlashloanUser is IFlashloanUser {
    function startFlashloan(
        address flashloanProvider,
        uint256 amount,
        address token
    ) external {
        FlashloanProvider(flashloanProvider).executeFlashloan(
            address(this),
            amount,
            token,
            bytes("")
        );
    }

    function flashloanCallback(
        uint256 amount,
        address token,
        bytes memory data
    ) external override {
        // Do something with the flashloan (arbitrage, liquidation....)

        // Reimbures the borrowed token (the flashloan)
        IERC20(token).transfer(msg.sender, amount);
    }
}
