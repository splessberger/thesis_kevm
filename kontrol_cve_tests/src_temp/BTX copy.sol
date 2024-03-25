pragma solidity ^0.8.13;

contract Bittelux { 
	mapping (address => uint256) balances;
	mapping (address => mapping (address => uint256)) allowed;
	uint256 public totalSupply;
    address private _owner;

	function transfer(address _to, uint256 _value) public returns (bool success) {	
		balances[msg.sender] -= _value;
		balances[_to] += _value;
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		balances[_to] += _value;
		balances[_from] -= _value;
		allowed[_from][msg.sender] -= _value;
		return true;
	}

	function balanceOf(address _owner) public returns (uint256 balance) {
		return balances[_owner];
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		return true;
	}

	function allowance(address _owner, address _spender) public returns (uint256 remaining) {
	  return allowed[_owner][_spender];
	}

    //constructor function 
    constructor() public {
        _owner = msg.sender;
        balances[msg.sender] = 10000000000000000000000000000;
        totalSupply = 10000000000000000000000000000;
    }


    function mint(address account, uint256 amount) external returns (bool) {
        if(_owner != msg.sender) revert();
        require(account != address(0), "ERC20: mint to the zero address");

        totalSupply += amount;
        balances[account] += amount;
        return true;
    }
}