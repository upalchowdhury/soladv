// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint decimal = 10**18;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 1000000*uint256(decimal)); // 1,000,000 tokens with 18 decimal places
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        IERC20(address(this)).safeTransfer(recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        IERC20(address(this)).safeTransferFrom(sender, recipient, amount);
        return true;
    }


    function mint(address to, uint256 amount) public virtual {
        _mint(to,amount);
    }

    function burn(address form, uint amount) public virtual {
        _burn(form, amount);
    }
}