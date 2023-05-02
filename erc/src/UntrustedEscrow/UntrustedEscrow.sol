pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "solmate/src/utils/ReentrancyGuard.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";




contract SaferUntrustedEscrow is ReentrancyGuard {
    using SafeMath for uint256;

    address public immutable buyer;
    address payable public immutable seller;
    uint private amount;
    uint public immutable releaseTime;
    bool public released = false;
    //ERC20 public token;
    
    constructor(address _buyer, address payable _seller, uint _amount) payable {
        require(_buyer != address(0), "Invalid buyer address");
        require(_seller != address(0), "Invalid seller address");
        require(msg.value == _amount, "Insufficient funds");
        buyer = _buyer;
        seller = _seller;
        amount = _amount;
        releaseTime = block.timestamp + 3 days;
    

    }


    
    modifier onlySeller() {
        require(msg.sender == seller,'not seller');
        _;
    }

    function deposit(address tokenAddress,uint256 _amount) external payable nonReentrant() {
        ERC20 token = ERC20(tokenAddress);
        require(msg.sender == buyer, "Only the buyer can deposit.");
        require(_amount > 0, "Amount must be greater than zero.");
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance.");
        require(token.allowance(msg.sender, address(this)) >= _amount, "Token allowance too low.");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed.");
        amount = amount.add(_amount);
    }
    
    function release() public nonReentrant() onlySeller() {
        require(msg.sender == seller, "Only the buyer can release the funds");
        require(releaseTime <= block.timestamp, "Release time has not yet been reached");
        require(!released, "Funds have already been released");
        (bool success, ) = seller.call{value: amount}("");
        require(success, "Failed to send ether to seller");
        released = true;

    }

    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    receive() external payable {
        require(msg.sender == seller, "Only the seller can send ether to the contract");
    }

    
}