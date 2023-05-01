pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "solmate/src/utils/ReentrancyGuard.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";





pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SaferUntrustedEscrow is ReentrancyGuard {
    using SafeMath for uint256;


============================================= follow below =====================




contract SaferUntrustedEscrow is IERC20, ERC20, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;


    address public immutable buyer;
    address payable public immutable seller;
    uint public immutable amount;
    uint public immutable releaseTime;
    bool public released = false;
    IERC20 public token;
    
    constructor(address _buyer, address payable _seller, uint _amount, address _token) payable {
        require(_buyer != address(0), "Invalid buyer address");
        require(_seller != address(0), "Invalid seller address");
        require(msg.value == _amount, "Insufficient funds");
        buyer = _buyer;
        seller = _seller;
        amount = _amount;
        releaseTime = block.timestamp + 3 days;
        token = IERC20(_token);

    }

    function deposit(ERC20 token,uint256 _amount) external nonReentrant {
        require(msg.sender == buyer, "Only the buyer can deposit.");
        require(_amount > 0, "Amount must be greater than zero.");
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient balance.");
        require(token.allowance(msg.sender, address(this)) >= _amount, "Token allowance too low.");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed.");
        amount = amount.add(_amount);
    }
    
    function release() public nonReentrant {
        require(msg.sender == buyer, "Only the buyer can release the funds");
        require(releaseTime <= block.timestamp, "Release time has not yet been reached");
        require(!released, "Funds have already been released");
        released = true;
        (bool success, ) = seller.call{value: amount}("");
        require(success, "Failed to send ether to seller");
    }
    
    function cancel() public {
        require(msg.sender == seller, "Only the seller can cancel the contract");
        require(!released, "Funds have already been released");
        selfdestruct(seller);
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    receive() external payable {
        require(msg.sender == seller, "Only the seller can send ether to the contract");
    }

    
}
