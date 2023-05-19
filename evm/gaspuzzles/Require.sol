// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Nft.sol";

contract Require {
    // Do not modify these variables
    uint256 constant COOLDOWN = 1 minutes;
    uint256 lastPurchaseTime;


    uint256 constant REQUIRED_VALUE = 100000000000000000; // 0.1 ether in Wei since its static value storing as constant

    /**
    * @notice By storing the contract address in a variable instead of accessing it directly can save gas on each access
    */
    NFToken tokenContract = NFToken(0x8431717927C4a3343bCf1626e7B5B1D31E240406);

    // Optimize this function
    function purchaseToken(uint tokenId) external payable {
        address purchaser = msg.sender;
        uint256 expirationTime = lastPurchaseTime + COOLDOWN;
        require(msg.value == 0.1 ether && block.timestamp > expirationTime,'cannot purchase');
        lastPurchaseTime = block.timestamp;
        // mint the user a token
        tokenContract.mint(purchaser,tokenId);



    }
}

//100000000000000000

// execution cost 59193
//gas	92457 gas
//transaction cost	80397 gas
