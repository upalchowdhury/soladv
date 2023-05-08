// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


import "forge-std/Test.sol";
import "../src/NftContract.sol";
import "../src/NftStaking.sol";
import "../src/RewardToken";

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";




contract Handler is CommonBase, StdCheats, StdUtils {
    DiscountedNFT public nft;

    constructor(IERC20 token) {
        token = IERC20(token);
        deal(address(this), 10 ether);
    }

    function deposit(uint256 amount) public {
        token.deposit{ value: amount }();
    }
}

