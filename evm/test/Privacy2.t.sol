// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Extractor {
    function getSlotValue(address contractAddress, uint256 slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            // Calculate the memory location where the slot value will be copied to
            let memLocation := mload(0x40)
            
            // Prepare the input data for extcodecopy
            mstore(memLocation, slot)
            
            // Call extcodecopy to copy the slot value from the contract to memory
            extcodecopy(contractAddress, memLocation, slot, 32)
            
           
            value := mload(memLocation)
        
        }
        
        return value;
    }
}