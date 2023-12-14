// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBeerToken.sol";
import "./IERC223.sol";
import "./IERC223Recipient.sol";

contract BeerToken is IBeerToken, IERC223 {
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address private _owner;

    constructor() {
        _name = 'BeerToken';
        _symbol = 'BT';
        _owner = msg.sender;
    }

    function name() external view override(IBeerToken, IERC223) returns (string memory) {
        return _name;
    }

    function symbol() external view override(IBeerToken, IERC223) returns (string memory) {
        return _symbol;
    }

    function decimals() external view override(IBeerToken, IERC223) returns (uint8) {
        return 0;
    }

    function totalSupply() external view override(IBeerToken, IERC223) returns (uint256) {
        return _totalSupply;
    }

    function standard() external view override(IERC223) returns (string memory) {
        return 'erc223';
    }

    function balanceOf(address account) external override(IBeerToken, IERC223) view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint value) external override(IBeerToken, IERC223) returns (bool success) {
        bytes memory _empty = hex"00000000";
        _balances[msg.sender] = _balances[msg.sender] - value;
        _balances[to] = _balances[to] + value;
        emit Transfer(msg.sender, to, value);
        emit TransferData(_empty);
        return true;
    }

    function transfer(address to, uint256 value, bytes calldata data) external override(IBeerToken, IERC223) returns (bool success) {
        _balances[msg.sender] = _balances[msg.sender] - value;
        _balances[to] = _balances[to] + value;
        emit Transfer(msg.sender, to, value);
        emit TransferData(data);
        return true;
    }

    function mint(address account, uint256 amount) external override(IBeerToken) returns (bool success) {
        if(_owner != msg.sender) revert();
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }

    function burn(uint256 amount) external override(IBeerToken) {
        uint256 accountBalance = _balances[msg.sender];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
        _balances[msg.sender] = accountBalance - amount;
    }
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function _isContract(
        address _to
    ) internal view returns (bool) {
        uint codeLength = 0;
        assembly {
            codeLength := extcodesize(_to)
        }
        return codeLength > 0;
    }
}
