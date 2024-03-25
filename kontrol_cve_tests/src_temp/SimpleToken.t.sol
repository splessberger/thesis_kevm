// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/SimpleToken.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract SimpleTokenTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    SimpleToken token; // Contract under test


    // modifier symbolic() {
    //     kevm.symbolicStorage(address(token));
    //     _;
    // }

    function setUp() public {
        token = new SimpleToken();
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

    function testTransfer(address bob, address alice, uint256 amount) public {
    	kevm.infiniteGas();
		
		vm.assume(alice != address(0));
		vm.assume(alice != address(token));
		vm.assume(alice != address(this));
		vm.assume(bob != address(0));
		vm.assume(bob != address(token));
		vm.assume(bob != address(this));
		vm.assume(bob != alice);
		vm.assume(notBuiltinAddress(alice));
		vm.assume(notBuiltinAddress(bob));
		vm.assume(token.totalSupply() > 0);
		vm.assume(amount > 0);

        bytes32 storageLocationAlice = hashedLocation(alice, 0);
        bytes32 storageLocationBob = hashedLocation(bob, 0);
        vm.assume(storageLocationAlice != storageLocationBob);
		
		// vm.assume(amount < MAX_INT);
		// vm.assume(totalSupply > 0);
		// vm.assume(totalSupply < MAX_INT);
		vm.assume(token.balanceOf(alice) > 0);
		// vm.assume(balanceAlice < MAX_INT);
		vm.assume(token.balanceOf(bob) > 0);
		// vm.assume(balanceBob < MAX_INT);
		vm.assume((token.balanceOf(alice) + amount) < MAX_INT);
		// vm.assume((balanceBob - amount) > 0);
		// vm.assume(balanceAlice < totalSupply);
		// vm.assume(balanceBob < totalSupply);

		vm.assume((amount + token.balanceOf(alice)) <= (token.balanceOf(alice) + token.balanceOf(bob)));
		vm.assume((token.balanceOf(alice) + token.balanceOf(bob)) <= token.totalSupply());
		vm.assume(token.totalSupply() <= MAX_INT);

		vm.assume(token.balanceOf(alice) <= (MAX_INT - amount)); //Arithmetic Overflow guard
		vm.assume(token.balanceOf(bob) >= amount); //Arithmetic Underflow guard

		uint256 newBalanceAlice = (token.balanceOf(alice) + amount);
		uint256 newBalanceBob = (token.balanceOf(bob) - amount);

		vm.prank(bob);
		token.transfer(alice, amount);

		assertEq(token.balanceOf(alice), newBalanceAlice);
		assertEq(token.balanceOf(bob), newBalanceBob);

		//assertLe((amount + balanceAlice), (balanceAlice + balanceBob));
		assertLe((token.balanceOf(alice) + token.balanceOf(bob)), token.totalSupply());
		assertLe(token.totalSupply(), MAX_INT);
    }
}