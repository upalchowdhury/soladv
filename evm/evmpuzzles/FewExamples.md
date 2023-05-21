## Puzzle 8

### Puzzle 
00      36        CALLDATASIZE
01      6000      PUSH1 00
03      80        DUP1
04      37        CALLDATACOPY
05      36        CALLDATASIZE
06      6000      PUSH1 00
08      6000      PUSH1 00
0A      F0        CREATE
0B      6000      PUSH1 00
0D      80        DUP1
0E      80        DUP1
0F      80        DUP1
10      80        DUP1
11      94        SWAP5
12      5A        GAS
13      F1        CALL
14      6000      PUSH1 00
16      14        EQ
17      601B      PUSH1 1B
19      57        JUMPI
1A      FD        REVERT
1B      5B        JUMPDEST
1C      00        STOP



## Solution

    CALLDATASIZE
    PUSH1 00
    DUP1
    CALLDATACOPY

    CALLDATASIZE
    PUSH1 00
    PUSH1 00
    CREATE

    PUSH1 00
    DUP1
    DUP1
    DUP1
    DUP1
    SWAP5
    GAS
    CALL

    PUSH1 00
    EQ
    PUSH1 1B
    JUMPI
    REVERT
    JUMPDEST
    STOP

## The above test resulted in that we need to return REVERT opcode through contract creation. Below opcode return the REVERT opcode (FD)
// store  REVERT opcode in memory the
PUSH1 FD
PUSH1 00
MSTORE8

// make the constructor return the stored runtime code
PUSH1 01
PUSH1 00
RETURN

## The above translates to `0x60FD60005360016000F3` which would be the code for the contract

#### This solution is very similiar to Ethernaut's Magic Number