// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract ERC721_test is ERC721 {
    uint256 tokenId;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address to) external returns (uint256 id) {
        _mint(to, tokenId);
        id = tokenId;
        tokenId++;
    }
}
