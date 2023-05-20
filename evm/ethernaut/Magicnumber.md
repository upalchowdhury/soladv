
## The bytecode for returning 42 is: 0x602A60005260206000F3 which transaltes to below opcode 
PUSH1   2a
PUSH1   00
MSTORE
PUSH1   20
PUSH1   00
RETURN


## Deploy the above in a contract for returning 42 or 0x602A60005260206000F3

PUSH10  602A60005260206000F3
PUSH1   00
MSTORE
PUSH1   0A
PUSH1   16
RETURN

The final bytecode of the deployment part of the contract is 0x69602A60005260206000F3600052600A6016F3