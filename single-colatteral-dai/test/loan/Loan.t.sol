// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";

import {WETH9} from "../../src/weth9.sol";

//import {DSToken} from "../../deps/token.sol";
import {SaiTub} from "../../src/tub.sol";
import {DSValue} from "../../deps/value.sol";
import {SaiVox} from "../../src/vox.sol";
import {GemPit} from "../../src/pit.sol";
import {DSMath} from "../../deps/math.sol";


import '../../deps/guard.sol';

import '../../src/tap.sol';

//import "./test.sol";
contract Loantest is Test, DSMath {
    WETH9 public weth;
    //DSToken public token;

/////////////////// different tokens ///////////////
    // DSToken  public  sai;  // Stablecoin
    // DSToken  public  sin;  // Debt (negative sai)

    // DSToken  public  skr;  // Abstracted collateral
    // ERC20    public  gem;  // Underlying collateral

    // DSToken  public  gov;  // Governance token

    // SaiVox   public  vox;  // Target price feed
    // DSValue  public  pip;  // Reference price feed
    // DSValue  public  pep;  // Governance price feed

    // SaiTap  public  tap;  // Liquidator
    // GemPit  public  pit;  // Governance Vault

    // uint256  public  axe;  // Liquidation penalty
    // uint256  public  cap;  // Debt ceiling
    // uint256  public  mat;  // Liquidation ratio
    // uint256  public  tax;  // Stability fee
    // uint256  public  fee;  // Governance fee
    // uint256  public  gap;  // Join-Exit Spread

    // bool     public  off;  // Cage flag
    // bool     public  out;  // Post cage exit

    // uint256  public  fit;  // REF per SKR (just before settlement)

    // uint256  public  rho;  // Time of last drip
    // uint256         _chi;  // Accumulated Tax Rates
    // uint256         _rhi;  // Accumulated Tax + Fee Rates
    // uint256  public  rum;  // Total normalised debt

    // uint256                   public  cupi;
    // mapping (bytes32 => Cup)  public  cups;


    SaiTap  tap;
    SaiTub  tub;
    SaiVox  vox;

    DSGuard dad;

    DSValue pip;
    DSValue pep;

    DSToken sai;
    DSToken sin;
    DSToken skr;
    DSToken gem;
    DSToken gov;

    address alice_user1;
    address bob_user2 ;


    function setUp() public {
        alice_user1 = vm.addr(0x1);
        bob_user2 = vm.addr(0x2);


        // Tokens
        sai = new DSToken("SAI");
        sin = new DSToken("SIN");
        skr = new DSToken("SKR");
        gem = new DSToken("GEM");
        gov = new DSToken("GOV");

        //  price feeds math calculations
        pip = new DSValue();
        pep = new DSValue();
        vox = new SaiVox(RAY);

        // Admin Role
        dad = new DSGuard();



        
        tub = new SaiTub(sai, sin, skr, gem, gov, pip, pep, vox, GemPit(address(0x123)));
        tap = SaiTap(address(0x456));
        tub.turn(tap);

        //Set whitelist authority
        skr.setAuthority(dad);

        //Permit tub to 'mint' and 'burn' SKR
        dad.permit(address(tub), address(skr), bytes4(keccak256('mint(address,uint256)')));
        dad.permit(address(tub), address(skr), bytes4(keccak256('burn(address,uint256)')));

        //Allow tub to mint, burn, and transfer gem/skr without approval
        gem.approve(address(tub));
        skr.approve(address(tub));
        sai.approve(address(tub));

        gem.mint(6 ether);
        
    }

    function testInitialTokenBalance() public {

        gem.mint(6 ether);

        //Verify initial token balances
        assertEq(gem.balanceOf(address(this)), 6 ether);
        assertEq(gem.balanceOf(address(tub)), 0 ether);
        assertEq(skr.totalSupply(), 0 ether);

        assert(!tub.off());

    }

    // Fuzzing
    function testInitialTokenBalanceFuzz(uint data,uint data2, uint data3) public {
        data = bound(data,1,10000);
        data2 = bound(data2,1,2000);
        data3 = bound(data3,3,800);

        gem.mint(data);

        //Verify initial token balances
        assertEq(gem.balanceOf(address(this)), data);
        assertEq(gem.balanceOf(address(tub)), 0 ether);
        assertEq(skr.totalSupply(), 0 ether);

        assert(!tub.off());

    }



    function testPie() public {
        assertEq(tub.pie(), gem.balanceOf(address(tub)));
        assertEq(tub.pie(), 0 ether);
        gem.mint(75 ether);
        tub.join(72 ether);
        assertEq(tub.pie(), gem.balanceOf(address(tub)));
        assertEq(tub.pie(), 72 ether);
    }

    function testPer() public {
        tub.join(5 ether);
        assertEq(skr.totalSupply(), 5 ether);
        assertEq(tub.per(), rdiv(5 ether, 5 ether));
    }


     function testFailTurnAgain() public {
        tub.turn(SaiTap(address(0x789)));
    }

    function testTag() public {
        tub.pip().poke(bytes32(uint256(1 ether)));
        assertEq(tub.pip().read(), bytes32(uint256(1 ether)));
        assertEq(wmul(tub.per(), uint(tub.pip().read())), tub.tag());
        tub.pip().poke(bytes32(uint256(5 ether)));
        assertEq(tub.pip().read(), bytes32(uint256(5 ether)));
        assertEq(wmul(tub.per(), uint(tub.pip().read())), tub.tag());
    }

    function testGap() public {
        assertEq(tub.gap(), WAD);
        tub.mold('gap', 2 ether);
        assertEq(tub.gap(), 2 ether);
        tub.mold('gap', wmul(WAD, 10 ether));
        assertEq(tub.gap(), wmul(WAD, 10 ether));
    }

    function testAsk() public {
        assertEq(tub.per(), RAY);
        assertEq(tub.ask(3 ether), rmul(3 ether, wmul(RAY, tub.gap())));
        assertEq(tub.ask(wmul(WAD, 33)), rmul(wmul(WAD, 33), wmul(RAY, tub.gap())));
    }

    function testBid() public {
        assertEq(tub.per(), RAY);
        assertEq(tub.bid(4 ether), rmul(4 ether, wmul(tub.per(), sub(2 * WAD, tub.gap()))));
        assertEq(tub.bid(wmul(5 ether,3333333)), rmul(wmul(5 ether,3333333), wmul(tub.per(), sub(2 * WAD, tub.gap()))));
    }

    function testJoin() public {
        tub.join(3 ether);
        assertEq(gem.balanceOf(address(this)), 3 ether);
        assertEq(gem.balanceOf(address(tub)), 3 ether);
        assertEq(skr.totalSupply(), 3 ether);
        tub.join(1 ether);
        assertEq(gem.balanceOf(address(this)), 2 ether);
        assertEq(gem.balanceOf(address(tub)), 4 ether);
        assertEq(skr.totalSupply(), 4 ether);
    }

    function testExit() public {
        gem.mint(10 ether);
        assertEq(gem.balanceOf(address(this)), 16 ether);

        tub.join(12 ether);
        assertEq(gem.balanceOf(address(tub)), 12 ether);
        assertEq(gem.balanceOf(address(this)), 4 ether);
        assertEq(skr.totalSupply(), 12 ether);

        tub.exit(3 ether);
        assertEq(gem.balanceOf(address(tub)), 9 ether);
        assertEq(gem.balanceOf(address(this)), 7 ether);
        assertEq(skr.totalSupply(), 9 ether);

        tub.exit(7 ether);
        assertEq(gem.balanceOf(address(tub)), 2 ether);
        assertEq(gem.balanceOf(address(this)), 14 ether);
        assertEq(skr.totalSupply(), 2 ether);
    }

    function testCage() public {
        tub.join(5 ether);
        assertEq(gem.balanceOf(address(tub)), 5 ether);
        assertEq(gem.balanceOf(address(this)), 1 ether);
        assertEq(skr.totalSupply(), 5 ether);
        assert(!tub.off());

        tub.cage(tub.per(), 5 ether);
        assertEq(gem.balanceOf(address(tub)), 0 ether);
        assertEq(gem.balanceOf(address(tap)), 5 ether);
        assertEq(skr.totalSupply(), 5 ether);
        assert(tub.off());
    }

    function testFlow() public {
        tub.join(1 ether);
        tub.cage(tub.per(), 1 ether);
        assert(tub.off());
        assert(!tub.out());
        tub.flow();
        assert(tub.out());
    }


}