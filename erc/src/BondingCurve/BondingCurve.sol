// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "erc1363/contracts/token/ERC1363/ERC1363.sol";
import "erc1363/contracts/token/ERC1363/IERC1363.sol";
import "solmate/src/utils/FixedPointMathLib.sol";
import "solmate/src/utils/ReentrancyGuard.sol";



contract BondingCurve is ERC1363, ReentrancyGuard {

using SafeMath for uint256;

//decimal
uint256 dec = 10**18;

// multiple is the cost of 1 * multple tokens
uint256 public multiple = 10**8;


// Mapping from token owner to their balance
mapping(address => uint256) public balances;

// Pool balance
uint256 public poolBalance = 0;


// totalSupply
//uint256 public totalSupply;


//reseve token
address reserveToken;

event Minted(uint256 amount, uint256 price);
event Burned(uint256 amount, uint256 refundAM);


    constructor(ERC1363 _token)  {
        reserveToken = _token;
    }



  function getBuyPrice(uint256 tokenAmount) public view returns(uint) {
    uint256 totalTokens = tokenAmount + totalSupply;
    uint256 m = multiple;
    uint256 d = dec;
    uint256 finalPrice = m * totalTokens * totalTokens / ( 2 * d * d ) - poolBalance;
    return finalPrice;
  }


  /**
   * @param tokenAmount token amount param
   * @return  finalPrice
   */
  function getSellPrice(uint256 tokenAmount) public view returns(uint) {
    require(totalSupply >= tokenAmount);
    uint256 totalTokens = totalSupply - tokenAmount;
    uint256 m = multiple;
    uint256 d = dec;
    uint256 finalPrice = poolBalance - m * totalTokens * totalTokens / ( 2 * d * d ); // integration of  y = mx
    return finalPrice;
  }

     // @dev Mint new tokens with ether
    function mint(uint256 numTokens) public payable nonReentrant() {
        uint256 priceForTokens = getBuyPrice(numTokens);
        require(msg.value >= priceForTokens);

        totalSupply = totalSupply.add(numTokens);
        balances[msg.sender] = balances[msg.sender].add(numTokens);
        poolBalance = poolBalance.add(priceForTokens);
        if (msg.value > priceForTokens) {
            transferAndCall(msg.sender,msg.value - priceForTokens);
        }

        emit Minted(numTokens, priceForTokens);
    }

//@dev  Burn tokens to receive ether
    function burn(uint256 numTokens) public nonReentrant() {
        require(balances[msg.sender] >= numTokens);

        uint256 ethToReturn = getSellPrice(numTokens);
        totalSupply = totalSupply.sub(numTokens);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        poolBalance = poolBalance.sub(ethToReturn);
        transferAndCall(msg.sender,ethToReturn);

        emit Burned(numTokens, ethToReturn);
    }


}

