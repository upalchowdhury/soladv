pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract FungibleToken is IERC20 {
    string public constant name = "My Fungible Token";
    string public constant symbol = "MFT";
    uint8 public constant decimals = 18;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _banned;

    address private _admin;

    constructor() {
        _admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Only the admin can perform this action.");
        _;
    }

    function banAddress(address account) external onlyAdmin {
        _banned[account] = true;
    }

    function unbanAddress(address account) external onlyAdmin {
        _banned[account] = false;
    }

    function isBanned(address account) public view returns (bool) {
        return _banned[account];
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!_banned[msg.sender], "You are banned from sending tokens.");
        require(!_banned[recipient], "The recipient is banned from receiving tokens.");
        require(msg.sender != address(0), "Invalid sender address");
        require(recipient != address(0), "Invalid recipient address");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        require(!_banned[msg.sender], "You are banned from approving allowance.");
        require(msg.sender != address(0), "Invalid sender address");
        require(spender != address(0), "Invalid spender address");

        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(!_banned[sender], "The sender is banned from sending tokens.");
        require(!_banned[recipient], "The recipient is banned from receiving tokens.");
        require(sender != address(0), "Invalid sender address");
        require(recipient != address(0), "Invalid recipient address");

        uint256 allowed = _allowances[sender][msg.sender];
        require(allowed >= amount, "Not enough allowance.");

        _balances[

            =================================== 


pragma solidity ^0.8.0;

contract FungibleToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public isBanned;

    address public admin;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Ban(address indexed bannedAddress);
    event Unban(address indexed unbannedAddress);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
        admin = msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(!isBanned[msg.sender], "Sender is banned from transferring tokens");
        require(!isBanned[_to], "Recipient is banned from receiving tokens");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(!isBanned[_from], "Sender is banned from transferring tokens");
        require(!isBanned[_to], "Recipient is banned from receiving tokens");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function banAddress(address _address) public onlyAdmin {
        require(!isBanned[_address], "Address is already banned");

        isBanned[_address] = true;

        emit Ban(_address);
    }

    function unbanAddress(address _address) public onlyAdmin {
        require(isBanned[_address], "Address is not banned");

        isBanned[_address] = false;

        emit Unban(_address);
    }
}
=================================  3  ==============

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract MyToken is IERC20 {
    string public constant name = "My Token";
    string public constant symbol = "MTK";
    uint8 public constant decimals = 18;
    uint256 public override totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _banned;

    address private _admin;

    constructor() {
        _admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, "Only the admin can call this function.");
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
}
