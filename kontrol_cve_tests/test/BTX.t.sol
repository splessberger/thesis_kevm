// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/BTX.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract BTXTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    Bittelux token; // Contract under test


    modifier symbolic() {
        kevm.symbolicStorage(address(token));
        _;
    }

    function setUp() public {
        token = new Bittelux();
    }

    modifier unchangedStorage(bytes32 storageSlot) {
        bytes32 initialStorage = vm.load(address(token), storageSlot);
        _;
        bytes32 finalStorage = vm.load(address(token), storageSlot);
        assertEq(initialStorage, finalStorage);
    }

    function hashedLocation(address _key, bytes32 _index) public pure returns(bytes32) {
        // Returns the index hash of the storage slot of a map at location `index` and the key `_key`.
        // returns `keccak(#buf(32,_key) +Bytes #buf(32, index))
        return keccak256(abi.encode(_key, _index));
    }

    function testTransfer(address bob, address alice, uint256 amount, bytes32 storageSlot) public symbolic unchangedStorage(storageSlot) {
    	//kevm.infiniteGas();
		
		uint256 totalSupply = token.totalSupply();
		uint256 balanceAlice = token.balanceOf(alice);
		uint256 balanceBob = token.balanceOf(bob);
		vm.assume(alice != address(0));
		vm.assume(alice != address(token));
		vm.assume(alice != address(this));
		vm.assume(bob != address(0));
		vm.assume(bob != address(token));
		vm.assume(bob != address(this));
		vm.assume(bob != alice);
		vm.assume(notBuiltinAddress(alice));
		vm.assume(notBuiltinAddress(bob));
		vm.assume(totalSupply > 0);
		vm.assume(amount > 0);

        bytes32 storageLocationAlice = hashedLocation(alice, 0);
        bytes32 storageLocationBob = hashedLocation(bob, 0);
        vm.assume(storageLocationAlice != storageLocationBob);
		
		// vm.assume(amount < MAX_INT);
		// vm.assume(totalSupply > 0);
		// vm.assume(totalSupply < MAX_INT);
		vm.assume(balanceAlice > 0);
		// vm.assume(balanceAlice < MAX_INT);
		vm.assume(balanceBob > 0);
		// vm.assume(balanceBob < MAX_INT);
		vm.assume((balanceAlice + amount) < MAX_INT);
		// vm.assume((balanceBob - amount) > 0);
		// vm.assume(balanceAlice < totalSupply);
		// vm.assume(balanceBob < totalSupply);

		vm.assume((amount + balanceAlice) <= (balanceAlice + balanceBob));
		vm.assume((balanceAlice + balanceBob) <= totalSupply);
		vm.assume(totalSupply <= MAX_INT);

		vm.assume(balanceAlice <= (MAX_INT - amount)); //Arithmetic Overflow guard
		vm.assume(balanceBob >= amount); //Arithmetic Underflow guard

		uint256 newBalanceAlice = (balanceAlice + amount);
		uint256 newBalanceBob = (balanceBob - amount);

		vm.prank(bob);
		token.transfer(alice, amount);

		assertEq(token.balanceOf(alice), newBalanceAlice);
		assertEq(token.balanceOf(bob), newBalanceBob);

		//assertLe((amount + balanceAlice), (balanceAlice + balanceBob));
		assertLe((token.balanceOf(alice) + token.balanceOf(bob)), totalSupply);
		assertLe(totalSupply, MAX_INT);
    }
}