// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/ETT.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract ETTTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    HashnodeTestCoin token; // Contract under test
	event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function setUp() public {
        token = new HashnodeTestCoin();
    }
	
    function hashedLocation(address _key, bytes32 _index) public pure returns(bytes32) {
        // Returns the index hash of the storage slot of a map at location `index` and the key `_key`.
        // returns `keccak(#buf(32,_key) +Bytes #buf(32, index))
        return keccak256(abi.encode(_key, _index));
    }

    function testTransfer(address alice, address bob, uint256 amount) public {
    	kevm.infiniteGas();
		
		vm.assume(bob != address(0));
		vm.assume(bob != address(token));
		vm.assume(bob != address(this));
		vm.assume(alice != address(0));
		vm.assume(alice != address(token));
		vm.assume(alice != address(this));
		vm.assume(address(0) != address(this));
		vm.assume(alice != bob);
		vm.assume(notBuiltinAddress(bob));
		vm.assume(notBuiltinAddress(alice));
		vm.assume(token.totalSupply() > 0);
		vm.assume(amount > 0);

		vm.assume((amount + token.balanceOf(bob)) <= (token.balanceOf(alice) + token.balanceOf(bob)));
		vm.assume((token.balanceOf(alice) + token.balanceOf(bob)) <= token.totalSupply());
		vm.assume(token.totalSupply() <= MAX_INT);

		uint256 newBalanceBob = (token.balanceOf(bob) + amount);
		uint256 newBalanceAlice = (token.balanceOf(alice) - amount);

		vm.prank(alice);
		token.transfer(bob, amount);

		assertEq(token.balanceOf(bob), newBalanceBob);
		assertEq(token.balanceOf(alice), newBalanceAlice);

		assertLe(token.balanceOf(bob), (token.balanceOf(alice) + token.balanceOf(bob)));
		assertLe((token.balanceOf(alice) + token.balanceOf(bob)), token.totalSupply());
		assertLe(token.totalSupply(), MAX_INT);
    }
}