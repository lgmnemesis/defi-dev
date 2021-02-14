// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LgmNFT is ERC721 {
    address public admin;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        admin = msg.sender;
    }

    function mint(address to, uint256 tokenId) external {
        require(msg.sender == admin, "Only admin");
        _safeMint(to, tokenId);
    }
}
