// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LgmWeth is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function deposit() external payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "balance too low");
        _burn(msg.sender, amount);
        msg.sender.transfer(amount);
    }
}
