## Third Gate

### uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)). 
### Make 0x11111111 be equal to 0x00001111 the mask to accomplish this is equal to 0x0000FFFF.

#### The second requirement say that the less important 8 bytes of the input must be different compared to the less important 4 bytes. We need to remember that we also need to maintain the first requirement. We need to make 0x00000000001111 != 0xXXXXXXXX00001111 To achieve that we need to update our mask to make all the first 4 bytes "pass" to the output Our new mask will be 0xFFFFFFFF0000FFFF

### Apply that mask to our tx.origin casted to a bytes8 

## bytes8(uint64(uint160(address(alice)))) & 0xFFFFFFFF0000FFFF.