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

import {Handler} from "./Handler.sol";



contract ContractTest is Test {

   Token1 token0;
   Token2 token1;
   AMM amm;
   Handler handler;

    
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
        handler = new Handler(amm);

        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = Handler.addLiquidity.selector;
        selectors[1] = Handler.swap.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));

        targetContract(address(handler));
       
       
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


    function testSwap() public {

        // First add liquidity 
        vm.startPrank(alice_user1);
        vm.deal(alice_user1,5 ether);
        token0.approve(address(amm),1000);
        token1.approve(address(amm),800);
        amm.addLiquidity(1000,800);
        assertEq(token0.balanceOf(address(amm)),uint256(1000));
        assertEq(token1.balanceOf(address(amm)),uint256(800));
        vm.stopPrank();

        // Swap token1 with token0
        vm.startPrank(bob_user2);
        token1.approve(address(amm),500);
        amm.swap(address(token1), 500);
        // Calculation based on the reserve (1000 * 498.5) / (800 + 498*5) = ~383
        assertEq(token0.balanceOf(bob_user2),383);
        vm.stopPrank();

    }



    function testSwapFuzz(uint data,uint data2, uint data3) public {
        data = bound(data,1,10000);
        data2 = bound(data2,1,2000);
        data3 = bound(data3,3,800);
        // First add liquidity 
        vm.startPrank(alice_user1);
        vm.deal(alice_user1,5 ether);
        token0.approve(address(amm),data);
        token1.approve(address(amm),data2);
        amm.addLiquidity(data,data2);
        assertEq(token0.balanceOf(address(amm)),uint256(data));
        assertEq(token1.balanceOf(address(amm)),uint256(data2));
        vm.stopPrank();

        //Swap token1 with token0
        vm.startPrank(bob_user2);
        token1.approve(address(amm),data3);
        amm.swap(address(token1), data3);
        // Calculation based on the reserve (1000 * 498.5) / (800 + 498.5) = ~383
        uint amountInAfterfee = (data3 * 997)/1000 ;
        uint amountOut = (data * amountInAfterfee) / (data2 + amountInAfterfee);
        assertEq(token0.balanceOf(bob_user2),amountOut);
        vm.stopPrank();

    }




    function invariant_liquidityDeposits() public {
        assertEq(
            token0.balanceOf(address(amm)),
            handler.LiqPair.token0()
        );
    }







    }



