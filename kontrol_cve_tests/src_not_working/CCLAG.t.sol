// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/CCLAG.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract CCLAGTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    ChuCunLingAIGO token; // Contract under test

    function setUp() public {
        token = new ChuCunLingAIGO(1000000, 'ChuCunLingAIGO', 0, 'CCLAG');
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
		vm.assume((balanceAlice + amount) <= MAX_INT); //Arithmetic Overflow guard
		vm.assume((balanceBob - amount) >= 0); //Arithmetic Underflow guard
		
		vm.assume((amount + balanceAlice) <= (balanceAlice + balanceBob));
		vm.assume((balanceAlice + balanceBob) <= totalSupply);
		vm.assume(totalSupply <= MAX_INT);
		
		vm.assume(amount < MAX_INT);
		vm.assume(totalSupply > 0);
		vm.assume(totalSupply < MAX_INT);
		vm.assume(balanceAlice > 0);
		vm.assume(balanceAlice < MAX_INT);
		vm.assume(balanceBob > 0);
		vm.assume(balanceBob < MAX_INT);
		vm.assume((balanceAlice + amount) < MAX_INT);
		vm.assume((balanceBob - amount) > 0);
		vm.assume(balanceAlice < totalSupply);
		vm.assume(balanceBob < totalSupply);

		uint256 newBalanceAlice = (balanceAlice + amount);
		uint256 newBalanceBob = (balanceBob - amount);

		vm.prank(bob);
		token.transfer(alice, amount);

		assertEq(token.balanceOf(alice), newBalanceAlice);
		assertEq(token.balanceOf(bob), newBalanceBob);
		assert(alice != address(0));
		assert(alice != address(token));
		assert(alice != address(this));
		assert(bob != address(0));
		assert(bob != address(token));
		assert(bob != address(this));

		assert((amount + balanceAlice) <= (balanceAlice + balanceBob));
		assert((balanceAlice + balanceBob) <= totalSupply);
		assert(totalSupply <= MAX_INT);
    }
}
