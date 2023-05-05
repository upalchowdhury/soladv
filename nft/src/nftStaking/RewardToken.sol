// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract RewardToken is ERC20, Ownable2Step {
    uint256 private _totalSupply = 1000000 * 10 ** 18;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, _totalSupply);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }
}