// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract NFToken is ERC721 {

    constructor() ERC721("MyNFT", "MNFT") {}



    function mint(address to, uint256 tokenId) external {
        _safeMint(to, tokenId);
    }
}