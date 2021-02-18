// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./IFlashloanUser.sol";

contract FlashloanProvider is ReentrancyGuard {
    mapping(address => IERC20) public tokens;

    constructor(address[] memory _tokens) {
        for (uint256 index = 0; index < _tokens.length; index++) {
            tokens[_tokens[index]] = IERC20(_tokens[index]);
        }
    }

    function executeFlashloan(
        address callback,
        uint256 amount,
        address _token,
        bytes memory data
    ) external nonReentrant() {
        IERC20 token = tokens[_token];
        uint256 originalBalance = token.balanceOf(address(this));
        require(address(token) != address(0), "token not supported");
        require(originalBalance >= amount, "amount too high");
        token.transfer(callback, amount);
        IFlashloanUser(callback).flashloanCallback(amount, _token, data);
        require(
            token.balanceOf(address(this)) == originalBalance,
            "flashloan not reimbursed"
        );
    }
}
