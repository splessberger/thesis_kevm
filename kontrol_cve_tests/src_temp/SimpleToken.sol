// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleToken {
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address private _owner;

    constructor() {
        _name = 'SimpleToken';
        _symbol = 'ST';
        _owner = msg.sender;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint8) {
        return 0;
    }

    function totalSupply() external view  returns (uint256) {
        return _totalSupply;
    }

    function standard() external pure returns (string memory) {
        return 'erc20';
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _balances[msg.sender] = _balances[msg.sender] - value;
        _balances[to] = _balances[to] + value;
        return true;
    }

    function mint(address account, uint256 amount) external returns (bool) {
        if(_owner != msg.sender) revert();
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        return true;
    }

    function burn(uint256 amount) external {
        uint256 accountBalance = _balances[msg.sender];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[msg.sender] = accountBalance - amount;
        _totalSupply -= amount;
    }
}
