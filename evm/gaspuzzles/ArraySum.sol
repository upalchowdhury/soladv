contract Optimizedarray {

    // Do not modify this
    uint256[] array;

    function setArray(uint256[] memory _array) external {
        require(_array.length <= 10, 'too long');
        array = _array;
    }
/**
 * @notice used unchecked and coppied storage data to memory
 *   previous cost 10762 gas
 *   after  cost    9597 gas
 */
    function getArraySum() external view returns (uint256) {
        uint256[] memory arrayNew = array;
        uint256  sum = 0;
        uint256 arrayLength = arrayNew.length;

        unchecked {
            for (uint256 i = 0; i < arrayLength; i++) {
                sum += arrayNew[i];
            }
        }

    return sum;
}

}

/**
 * @notice using assembly overall gas saving for deployment and reading are 
 *  previous cost 10762 gas
 *  after          9301 gas
 */

contract YulOpt {


    // Do not modify this
    uint256[] array;


    // Do not modify this
    function setArray(uint256[] memory _array) external {
        require(_array.length <= 10, 'too long');
        array = _array;
    }
        
        
        
    function getArraySum() external view returns (uint) {
        uint slot;
        uint sum;
        uint ret;
       
        assembly {
            slot := array.slot

        }

        bytes32 location = keccak256(abi.encode(slot));

        assembly {
            let arrayLength := sload(array.slot)

             for { let i := 0 } lt(i, arrayLength) { i := add(i, 1) } {
                ret := sload(add(location,i))
                sum := add(sum,ret)
            }
            
        }
        return sum;
    }
}
