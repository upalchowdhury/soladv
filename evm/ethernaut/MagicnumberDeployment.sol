contract MagicDep {

    function deploy() {
    // Deploy the raw bytecode `create` 
    address magicContract;
    assembly {
        let ptr := mload(0x40)
        mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3))
        magicContract := create(0, ptr, 0x13)
    }
    
}

}