// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "erc1363/contracts/token/ERC1363/ERC1363.sol";
import "erc1363/contracts/token/ERC1363/IERC1363.sol";
import "solmate/src/utils/FixedPointMathLib.sol";
import "solmate/src/utils/ReentrancyGuard.sol";

                      
                      // TODO

/**
 * property of power functions is that we can define our bonding curve in terms of a reserve ratio. 
Reserve ratio is defined by the relationship between token price, token supply and poolBalance.
*/

reserveRatio = poolBalance / (currentPrice * tokenSupply);




/////    BUY  ///////////
  function buy(uint256 buyAmount) public payable returns(bool) {
    require(buyAmount > 0);
    uint256 tokensToMint = calculatePurchaseReturn(totalSupply_, poolBalance, reserveRatio, msg.value);
    totalSupply_ = totalSupply_.add(tokensToMint);
    balances[msg.sender] = balances[msg.sender].add(tokensToMint);
    poolBalance = poolBalance.add(msg.value);
    emit (tokensToMint, msg.value);
    return true;
  }

//////// SELL /////////////
  /**
   * @dev Sell tokens
   * gas ~ 86936
   * @param sellAmount Amount of tokens to withdraw
   * TODO implement maxAmount that helps prevent miner front-running
   */
  function sell(uint256 sellAmount)  public returns(bool) {
    require(sellAmount > 0 && balances[msg.sender] >= sellAmount);
    uint256 ethAmount = calculateSaleReturn(totalSupply_, poolBalance, reserveRatio, sellAmount);
    msg.sender.transfer(ethAmount);
    poolBalance = poolBalance.sub(ethAmount);
    balances[msg.sender] = balances[msg.sender].sub(sellAmount);
    totalSupply_ = totalSupply_.sub(sellAmount);
    emit (sellAmount, ethAmount);
    return true;
  }










