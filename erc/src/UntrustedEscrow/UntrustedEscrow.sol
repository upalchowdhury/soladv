// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "solmate/src/utils/ReentrancyGuard.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "./CustomToken.sol";




contract SaferUntrustedEscrow is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public immutable buyer;
    address payable public immutable seller;
    uint private amount;
    uint public immutable releaseTime;
    bool public released = false;
    uint decimal = 10**8;
    
    constructor(address _buyer, address payable _seller) payable {
        require(_buyer != address(0), "Invalid buyer address");
        require(_seller != address(0), "Invalid seller address");
        buyer = _buyer;
        seller = _seller;
        //amount = _amount*uint256; // TODO calculate any ERC20 token's value to USD value
        releaseTime = block.timestamp + 3 days;
    }


    
    modifier onlySeller() {
        require(msg.sender == seller,'not seller');
        _;
    }
/**
     * @dev make escrow deposit to the the escrow contract. 
     * This deposit function will use safetransfer from custom toke contract. 
     */
    function deposit(address tokenAddress,uint256 _amount) external nonReentrant() {
        IERC20 token = IERC20(tokenAddress);
        //amount = _amount*uint(decimal);
        require(msg.sender == buyer, "Only the buyer can deposit.");
        require(_amount > 0, "Amount must be greater than zero.");
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance.");
        require(token.allowance(msg.sender, address(this)) >= amount, "Token allowance too low.");
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        amount = amount.add(amount);
    }
    
    function release() public nonReentrant() onlySeller() {
        require(releaseTime <= block.timestamp, "Release time has not yet been reached");
        require(!released, "Funds have already been released");
        (bool success, ) = seller.call{value: amount}("");
        require(success, "Failed to send ether to seller");
        released = true;

    }

    
    function getBalance(address tokenAddress) public view returns (uint) {
        IERC20 token = IERC20(tokenAddress);
        return token.balanceOf(address(this));
    }
    
    // receive() external payable {
    //     require(msg.sender == buyer, "Only the buyer can send ether to the contract");
    // }

    
}