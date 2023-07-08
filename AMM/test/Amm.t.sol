// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
// import {Token} from "./CustomToken.sol";
// import {Token2} from "./CustomToken2.sol";

import {Token1} from "./Token1.sol";
import {Token2} from "./Token2.sol";

//import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../src/Amm.sol";
//import {IERC20} from "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";



contract ContractTest is Test {

   Token1 token0;
   Token2 token1;
   AMM amm;

    
    address alice_user1 = vm.addr(0x1);
    address bob_user2 = vm.addr(0x2);


   
    function setUp() public {
        alice_user1 = vm.addr(0x1);
        bob_user2 = vm.addr(0x2);

     
        
        token0 = new Token1("ff","fff");
        token1 = new Token2("tt","fttf");

        // LP provider
        token0.transfer(alice_user1,10000);
        token1.transfer(alice_user1,10000);

        // Trader
        token1.transfer(bob_user2,12000);

        amm = new AMM(address(token0), address(token1));
       
       
    }

    // @dev signature for erc20 function deal(address token, address to, uint256 give) external;

     function testAddliquidity() public {
        vm.startPrank(alice_user1);
        vm.deal(alice_user1,5 ether);
        token0.approve(address(amm),1000);
        token1.approve(address(amm),800);
        amm.addLiquidity(1000,800);
        assertEq(token0.balanceOf(address(amm)),uint256(1000));
        assertEq(token1.balanceOf(address(amm)),uint256(800));
        vm.stopPrank();
       
    }





    }



    // function testName() external {
    //     assertEq("KOIN",token.name());
    // }

    // function addGodAddress() external {
    //     vm.prank(alice);
    //     token.addSpecialAddress(bob);
    //     assertEq(token.getSpAd(bob),true);
    // }
