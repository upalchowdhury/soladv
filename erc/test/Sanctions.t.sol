// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "../src/Stoppable.sol";
// import "../src/MERC20.sol";

// contract CounterTest is Test {
//    StakeContract public stakeContract;
//    MockERC20 public mockToken; 

//     function setUp() public {
//         stakeContract = new StakeContract();
//         mockToken = new MockERC20();
//     }

//     function test_staking_tokens_fuzz(uint256 amount) public {
//         uint256 amount = 10e18;
//         mockToken.approve(address(stakeContract), amount);
//         bool stakePassed = stakeContract.stake(amount, address(mockToken));
//         assertTrue(stakePassed);
//     }
// }


import "forge-std/Test.sol";
import "../src/Sanctions.sol";


contract ContractTest is Test {

    Token token;

    
    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);
    address notsanctioned1 = vm.addr(0x3);
    address notsanctioned2 = vm.addr(0x4);


   
    function setUp() public {
        token = new Token(1000000);
    }

    function testName() external {
        assertEq("KOIN",token.name());
    }


    function testBan() public {
        token.ban(alice);
        assertEq(token.banned[alice],true);
    }

    function testFailMint() public {
        token.mint(alice, 2e18);
        vm.expectRevert("This address is banned");
    }

    function testMint() public {
        token.mint(notsanctioned1, 2e18);
        assertEq(token.balanceOf(notsanctioned1),uint256(2e18));
    }


    function testTransfer() external {
        testMint();
        vm.startPrank(notsanctioned1);
        token.transfer(notsanctioned2, 0.5e18);
        assertEq(token.balanceOf(notsanctioned2), 0.5e18);
        assertEq(token.balanceOf(notsanctioned1), 1.5e18);
        vm.stopPrank();
    }

    function testTransferFrom() external {
        testMint()
        vm.prank(notsanctioned1);
        token.approve(address(this), 1e18);
        assertTrue(token.transferFrom(notsanctioned1,bob, 0.7e18));
        assertEq(token.allowance(notsanctioned1, address(this)), 1e18 - 0.7e18);
        assertEq(token.balanceOf(notsanctioned1), 2e18 - 0.7e18);
        assertEq(token.balanceOf(bob), 0.7e18);
    }

    function testFailMintToZero() external {
        token.mint(address(0), 1e18);
    }

    function testFailBurnFromZero() external {
        token.burn(address(0) , 1e18);
    }

    
    function testFailTransferInsufficientBalance() external {
        testMint();
        vm.prank(notsanctioned1);
        token.transfer(bob , 4e18);
    }

    function testFailTransferFromInsufficientApprove() external {
        testMint();
        vm.prank(notsanctioned1);
        token.approve(address(this), 1e18);
        token.transferFrom(notsanctioned1, bob, 2e18);
    }

    function testFailTransferFromInsufficientBalance() external {
        testMint();
        vm.prank(notsanctioned1);
        token.approve(address(this), type(uint).max);

        token.transferFrom(notsanctioned1, bob, 6e18);
    }

    /*****************************/
    /*      Fuzz Testing         */
    /*****************************/

    function testFuzzMint(address to, uint256 amount) external {
        vm.assume(to != address(0));
        token.mint(to,amount);
        assertEq(token.totalSupply(), token.balanceOf(to));
    }

    function testFuzzApprove(address to, uint256 amount) external {
        vm.assume(to != address(0));
        assertTrue(token.approve(to,amount));
        assertEq(token.allowance(address(this),to), amount);
    }

    function testFuzzTransfer(address to, uint256 amount) external {
        vm.assume(to != address(0));
        vm.assume(to != address(this));
        token.mint(address(this), amount);
        
        assertTrue(token.transfer(to,amount));
        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(to), amount);
    }

    function testFuzzTransferFrom(address from, address to,uint256 approval, uint256 amount) external {
        vm.assume(from != address(0));
        vm.assume(to != address(0));

        amount = bound(amount, 0, approval);
        token.mint(from, amount);

        vm.prank(from);
        assertTrue(token.approve(address(this), approval));

        assertTrue(token.transferFrom(from, to, amount));
        assertEq(token.totalSupply(), amount);

        if (approval == type(uint256).max){
            assertEq(token.allowance(from, address(this)), approval);
        }
        else {
            assertEq(token.allowance(from,address(this)), approval - amount);
        }

        if (from == to) {
            assertEq(token.balanceOf(from), amount);
        } else {
            assertEq(token.balanceOf(from), 0);
            assertEq(token.balanceOf(to), amount);
        }
    }



    function testFailFuzzTransferFromInsufficientBalance(address from, address to, uint256 mintAmount, uint256 sentAmount) external {
        sentAmount = bound(sentAmount, mintAmount+1, type(uint256).max);

        token.mint(from, mintAmount);
        vm.prank(from);
        token.approve(address(this), type(uint256).max);

        token.transferFrom(from, to, sentAmount);
    }
    
}   