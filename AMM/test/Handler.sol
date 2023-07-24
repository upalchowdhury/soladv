pragma solidity ^0.8.13;

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {console} from "forge-std/console.sol";
import {AddressSet, LibAddressSet} from "./AddressSet.sol";
import {AMM} from  "../src/Amm.sol";


contract ForcePush {
    constructor(address dst) payable {
        selfdestruct(payable(dst));
    }
}



contract Handler is CommonBase, StdCheats, StdUtils {
    using LibAddressSet for AddressSet;

    AMM public amm;

    struct LiqPair {
        uint amount0;
        uint amount1;
    }

   


    mapping(bytes32 => uint256) public calls;

    AddressSet internal _actors;
    address internal currentActor;

    modifier createActor() {
        currentActor = msg.sender;
        _actors.add(msg.sender);
        _;
    }



    modifier useActor(uint256 actorIndexSeed) {
        currentActor = _actors.rand(actorIndexSeed);
        _;
    }

    function _pay(address to, uint256 amount) internal {
        (bool s,) = to.call{value: amount}("");
        require(s, "pay() failed");
    }

    function rand(AddressSet storage s, uint256 seed) internal view returns (address) {
        if (s.addrs.length > 0) {
            return s.addrs[seed % s.addrs.length];
        } else {
            return address(0);
        }
    }

    modifier countCall(bytes32 key) {
        calls[key]++;
        _;
    }

    constructor(AMM _amm) {
        amm = _amm;
    }

    function addLiquidity(uint amount0, uint amount1, LiqPair memory l) public createActor countCall("addLiquidity") {
        amount0 = bound(amount0,2,3000);
        amount1 = bound(amount1,3,4000);

        _pay(currentActor,amount0);
        _pay(currentActor,amount1);

        vm.prank(currentActor);

        amm.addLiquidity(amount0,amount1);


        l.amount0 += amount0;
        l.amount1 += amount1;


    }


    function swap(address _tokenIn, uint _amountIn) public createActor countCall("swap") {
         amountIn = bound(amountIn,2,3000);
         vm.prank(currentActor);
         amm.swap(amountIn);
    }

    
}