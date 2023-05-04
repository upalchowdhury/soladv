// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "solmate/src/utils/ReentrancyGuard.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract Token is ERC20 {



    uint256 private _totalSupply;

    uint8 public constant decimal = 18;
  

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _specialAddresses;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _specialAddresses[msg.sender] = true;
        mint(msg.sender, 1000000*uint256(decimal)); // 1,000,000 tokens with 18 decimal places
    }


/**
 * @dev only this special address allowed to mint and transfer toekns
 */
    modifier onlySpecial() {
        require(_specialAddresses[msg.sender], "Only the special address can call this function.");
        _;
    }

    function addSpecialAddress(address account) public onlySpecial {
        _specialAddresses[account] = true;
    }

    function removeSpecialAddress(address account) public onlySpecial {
        _specialAddresses[account] = false;
    }

    function getSpAd(address account) external returns (bool) {
        return  _specialAddresses[account];
    }

    function transfer(address recipient, uint256 amount) public override onlySpecial returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function mint(address to, uint256 amount) public virtual onlySpecial {
        _mint(to,amount);
    }

    function burn(address form, uint amount) public virtual onlySpecial {
        _burn(form, amount);
    }

}