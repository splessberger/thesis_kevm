// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/BTX.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract BTXTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    Bittelux token; // Contract under test

    function setUp() public {
        token = new Bittelux();
    }

    function testTransfer(address bob, address alice, uint256 amount) public {
    	kevm.infiniteGas();
		
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
		vm.assume(totalSupply > 0);
		vm.assume(amount > 0);
		vm.assume(balanceBob >= amount);
		
		// vm.assume(amount < MAX_INT);
		// vm.assume(totalSupply > 0);
		// vm.assume(totalSupply < MAX_INT);
		// vm.assume(balanceAlice > 0);
		// vm.assume(balanceAlice < MAX_INT);
		// vm.assume(balanceBob > 0);
		// vm.assume(balanceBob < MAX_INT);
		// vm.assume((balanceAlice + amount) < MAX_INT);
		// vm.assume((balanceBob - amount) > 0);
		// vm.assume(balanceAlice < totalSupply);
		// vm.assume(balanceBob < totalSupply);

		// vm.assume((amount + balanceAlice) <= (balanceAlice + balanceBob));
		// vm.assume((balanceAlice + balanceBob) <= totalSupply);
		// vm.assume(totalSupply <= MAX_INT);

		vm.assume((balanceAlice + amount) <= MAX_INT); //Arithmetic Overflow guard
		vm.assume((balanceBob - amount) >= 0); //Arithmetic Underflow guard

		uint256 newBalanceAlice = (balanceAlice + amount);
		uint256 newBalanceBob = (balanceBob - amount);

		vm.prank(bob);
		token.transfer(alice, amount);

		assertEq(token.balanceOf(alice), newBalanceAlice);
		assertEq(token.balanceOf(bob), newBalanceBob);
		assertNotEq(alice, address(0));
		assertNotEq(alice, address(token));
		assertNotEq(alice, address(this));
		assertNotEq(bob, address(0));
		assertNotEq(bob, address(token));
		assertNotEq(bob, address(this));

		assertLe((amount + balanceAlice), (balanceAlice + balanceBob));
		assertLe((balanceAlice + balanceBob), totalSupply);
		assertLe(totalSupply, MAX_INT);
    }
}