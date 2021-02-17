// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LgmLpToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
}
