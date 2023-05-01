pragma solidity ^0.8.0;

import "@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "solmate/src/utils/ReentrancyGuard.sol";
import "@openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";



contract Token is ERC20, IERC20 {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;


    uint256 public constant decimals = 10**18;
    uint256 private _totalSupply;
    string private name;
    string private symbol;


    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _banned;

    address private admin;

    
    constructor(uint256 _initialSupply) {
        admin = msg.sender;
        symbol = "KC";
        name = "KOIN";
        _totalSupply = _initialSupply;
        _balances[msg.sender] = _initialSupply;
        
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }

    function ban(address account) public onlyAdmin {
        _banned[account] = true;
    }

    function unban(address account) public onlyAdmin {
        _banned[account] = false;
    }

   function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!_banned[msg.sender], "You are banned from sending tokens.");
        require(!_banned[recipient], "Recipient is banned from receiving tokens.");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(!_banned[sender], "Sender is banned from sending tokens.");
        require(!_banned[recipient], "Recipient is banned from receiving tokens.");
        require(_allowances[sender][msg.sender] >= amount, "Transfer amount exceeds allowance.");
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Transfer from the zero address.");
        require(recipient != address(0), "Transfer to the zero address.");
        require(_balances[sender] >= amount, "Transfer amount exceeds balance.");
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "Approve from the zero address.");
        require(spender != address(0), "Approve to the zero address.");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function mint(address to, uint256 amount) public virtual {
        require(!_banned[to], "Recipient is banned from receiving tokens.");
        _mint(to,amount);
    }

    function burn(address from, uint amount) public virtual {
        require(!_banned[from], "Recipient is banned from receiving tokens.");
        _burn(form, amount);
    }

 
}