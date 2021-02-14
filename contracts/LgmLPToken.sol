// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LgmLPToken is ERC20 {
    IERC20 public collateral;
    uint256 price = 1;

    constructor(
        string memory name,
        string memory symbol,
        address _collateral
    ) ERC20(name, symbol) {
        collateral = IERC20(_collateral);
    }

    function deposit(uint256 collateralAmount) external {
        collateral.transferFrom(msg.sender, address(this), collateralAmount);
        _mint(msg.sender, collateralAmount * price);
    }

    function withdraw(uint256 tokenAmount) external {
        require(balanceOf(msg.sender) >= tokenAmount);
        _burn(msg.sender, tokenAmount);
        collateral.transfer(msg.sender, tokenAmount / price);
    }
}
