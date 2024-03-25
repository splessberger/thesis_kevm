// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/BTX.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract BTXTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    Bittelux token; // Contract under test
	event Transfer(address indexed _from, address indexed _to, uint256 _value);


    // modifier symbolic() {
    //     kevm.symbolicStorage(address(token));
    //     _;
    // }

    function setUp() public {
        token = new Bittelux();
    }
	
 	// modifier unchangedStorage(bytes32 storageSlot) {
    //     bytes32 initialStorage = vm.load(address(token), storageSlot);
    //     _;
    //     bytes32 finalStorage = vm.load(address(token), storageSlot);
    //     assertEq(initialStorage, finalStorage);
    // }

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

        // bytes32 storageLocationBob = hashedLocation(bob, 0);
        // bytes32 storageLocationAlice = hashedLocation(alice, 0);
        // vm.assume(storageLocationBob != storageLocationAlice);
		
		// vm.assume(token.totalSupply() < MAX_INT);
		// vm.assume(token.balanceOf(bob) > 0);
		// vm.assume(balanceBob < MAX_INT);
		// vm.assume(token.balanceOf(alice) > 0);
		// vm.assume(balanceAlice < MAX_INT);
		// vm.assume((token.balanceOf(alice) + amount) < MAX_INT);
		// vm.assume((balanceAlice - amount) > 0);
		// vm.assume(balanceBob < totalSupply);
		// vm.assume(balanceAlice < totalSupply);

		vm.assume((amount + token.balanceOf(bob)) <= (token.balanceOf(alice) + token.balanceOf(bob)));
		vm.assume((token.balanceOf(alice) + token.balanceOf(bob)) <= token.totalSupply());
		vm.assume(token.totalSupply() <= MAX_INT);

		// vm.assume(token.balanceOf(bob) < (MAX_INT - amount)); //Arithmetic Overflow guard
		// vm.assume(token.balanceOf(alice) > amount); //Arithmetic Underflow guard

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