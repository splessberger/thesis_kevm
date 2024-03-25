pragma solidity ^0.8.13;

import "./StandardToken.sol";

contract ChuCunLingAIGO is StandardToken {

	fallback() external {
		revert();
	}

	string public name;				   
	uint8 public decimals;			   
	string public symbol;				 
	string public version = 'H0.1';	   

	constructor(
		uint256 _initialAmount,
		string memory _tokenName,
		uint8 _decimalUnits,
		string memory _tokenSymbol
		) {
		balances[msg.sender] = _initialAmount;			   
		totalSupply = _initialAmount;						
		name = _tokenName;								   
		decimals = _decimalUnits;							
		symbol = _tokenSymbol;							   
	}

	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)  public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);		
		//if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
		return true;
	}
}