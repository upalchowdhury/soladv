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

        // math calculations
        pip = new DSValue();
        pep = new DSValue();

        // Admin Role
        dad = new DSGuard();



        vox = new SaiVox(RAY);
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

        //Verify initial token balances
        assertEq(gem.balanceOf(address(this)), 6 ether);
        assertEq(gem.balanceOf(address(tub)), 0 ether);
        assertEq(skr.totalSupply(), 0 ether);

        assert(!tub.off());
       
        
    }

    function testInitialTokenBalance() public {

        //Verify initial token balances
        assertEq(gem.balanceOf(address(this)), 6 ether);
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


}