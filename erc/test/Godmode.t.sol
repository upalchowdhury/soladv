// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GodMode.sol";

contract ContractTest is Test {

    Token token;

    
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);
    address vikas = vm.addr(0x3);
    address sean = vm.addr(0x4);

   
    function setUp() public {
        alice = vm.addr(0x1);
        bob = vm.addr(0x2);
        vikas = vm.addr(0x3);
        sean = vm.addr(0x4);

        vm.prank(alice);
        token = new Token("KOIN","KO");
       
       
    }

    // @dev signature for erc20 function deal(address token, address to, uint256 give) external;

     function testMint() public {
        token.mint(alice, 2e18);
        assertEq(token.balanceOf(alice),uint256(2e18));
    }



    function testName() external {
        assertEq("KOIN",token.name());
    }

    function addGodAddress() external {
        vm.prank(alice);
        token.addSpecialAddress(bob);
        assertEq(token.getSpAd(bob),true);
    }


    function testFailMint() external {
        vm.prank(vikas);
        token.mint(vikas, 2e18);
    }


}