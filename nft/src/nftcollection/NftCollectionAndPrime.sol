// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTCollection is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint constant cap = 20;

    constructor() ERC721("NFT Collection", "NFTC") {}

    function mintNFT(address recipient) external returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current() + 1;
        // uint newTokenId = generateRandomNumber();
        require((newTokenId <= cap),"No more tokens to mint");
        _mint(recipient, newTokenId);
     
        return newTokenId;
    }
// meetbits
//uint index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
//     function generateRandomNumber() internal view returns (uint256) {
//         uint256 randomNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
//         return (randomNumber % 20) + 1;
// }
}



contract PrimeNFTCounter {
    NFTCollection private nftCollection;

    constructor(address nftCollectionAddress) {
        nftCollection = NFTCollection(nftCollectionAddress);
    }

    function countPrimeNFTs(address owner) external view returns (uint256) {
        uint256 totalNFTs = nftCollection.balanceOf(owner);
        uint256 primeCount = 0;

        for (uint256 i = 0; i < totalNFTs; i++) {
            uint256 tokenId = nftCollection.tokenOfOwnerByIndex(owner, i);
            if (isPrime(tokenId)) {
                primeCount++;
            }
        }

        return primeCount;
    }

    function isPrime(uint256 number) internal pure returns (bool) {
        if (number <= 1) {
            return false;
        }

        for (uint256 i = 2; i * i <= number; i++) {
            if (number % i == 0) {
                return false;
            }
        }

        return true;
    }
}
