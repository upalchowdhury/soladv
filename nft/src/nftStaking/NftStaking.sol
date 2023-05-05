// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
// import "@openzeppelin/contracts/utils/structs/BitMaps.sol";
// import "@openzeppelin/contracts/interfaces/IERC2981.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
// //import "@openzeppelin/contracts/token/ERC721/extensions/IERC2917.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./RewardToken.sol";
import "./NftContract.sol";

contract StakingContract is ERC721Holder {
    uint256 public constant STAKE_DURATION = 1 days;
    uint256 public constant STAKE_AMOUNT = 10 * (10 ** 18); // 10 tokens

    RewardToken public rewardToken;
    IERC721 public nftContract;
    mapping(uint256 => Stake) public stakes;

    struct Stake {
        uint256 startTime;
        uint256 nftId;
    }

    constructor(RewardToken _rewardToken, IERC721 _nftContract) {
        rewardToken = _rewardToken;
        nftContract = _nftContract;
}

function stake(uint256 nftId) external {
    //nftContract = new DiscountedNFT
    require(nftContract.ownerOf(nftId) == msg.sender, "Not owner of NFT");
    require(stakes[nftId].startTime == 0, "NFT already staked");
    //nftContract.setApprovalForAll(address(this),true);
    nftContract.safeTransferFrom(msg.sender, address(this), nftId);

    stakes[nftId] = Stake({
        startTime: block.timestamp,
        nftId: nftId
    });
}

function withdraw(uint256 nftId) external {
    require(stakes[nftId].startTime > 0, "NFT not staked");
    require(block.timestamp >= stakes[nftId].startTime + STAKE_DURATION, "Stake not expired");

    uint256 reward = STAKE_AMOUNT;
    stakes[nftId].startTime = 0;
    rewardToken.mint(msg.sender, reward);

    nftContract.safeTransferFrom(address(this), msg.sender, nftId);
}

}