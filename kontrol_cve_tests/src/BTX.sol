pragma solidity ^0.8.13;

import "./StandardToken.sol";

contract Bittelux is StandardToken { 

    /* public variables of the token */

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'H1.0'; 
    uint256 public unitsOneEthCanBuy;
    uint256 public totalEthInWei; 
    address payable public fundsWallet;

    //constructor function 
    constructor() public {
        balances[msg.sender] = 10000000000000000000000000000;
        totalSupply = 10000000000000000000000000000;
        name = "Bittelux";
        decimals = 18;
        symbol = "BTX";
        unitsOneEthCanBuy = 22500;
        fundsWallet = payable(address(msg.sender));
    }

    receive() external payable {
        totalEthInWei = totalEthInWei + msg.value;
        uint256 amount = msg.value * unitsOneEthCanBuy;
        require(balances[fundsWallet] >= amount);

        balances[fundsWallet] = balances[fundsWallet] - amount;
        balances[msg.sender] = balances[msg.sender] + amount;

        emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain

        //Transfer ether to fundsWallet
        fundsWallet.transfer(msg.value);                               
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) external returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        (bool success, bytes memory data) = _spender.call(abi.encodeWithSignature("receiveApproval(address,uint256,address,bytes)", msg.sender, _value, this, _extraData));
        if(!success) { revert(); }
        return true;
    }
}