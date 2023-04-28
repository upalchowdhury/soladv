// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Stoppable.sol";
import "../src/MERC20.sol";

contract CounterTest is Test {
   StakeContract public stakeContract;
   MockERC20 public mockToken; 

    function setUp() public {
        stakeContract = new StakeContract();
        mockToken = new MockERC20();
    }

    function test_staking_tokens_fuzz(uint256 amount) public {
        uint256 amount = 10e18;
        mockToken.approve(address(stakeContract), amount);
        bool stakePassed = stakeContract.stake(amount, address(mockToken));
        assertTrue(stakePassed);
    }
}
