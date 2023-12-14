// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/SimpleToken.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

contract SimpleTokenTest is Test, KontrolCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    SimpleToken token; // Contract under test

    function setUp() public {
        token = new SimpleToken();
    }
    
    function testDecimals() public {
        assertEq(token.decimals(), 0);
    }
	
    function testBalanceOf(address alice) public {
    	bytes32 balanceAliceSlot = keccak256(
    		abi.encodePacked(uint256(uint160(alice)), uint256(0))
		);
		uint256 balanceAlice = uint256(vm.load(address(token), balanceAliceSlot));
		assertEq(token.balanceOf(alice), balanceAlice);
    }

    function testMint(address alice, uint256 amount) public {
    	kevm.infiniteGas();
		
		uint256 totalSupply = token.totalSupply();
		uint256 balanceAlice = token.balanceOf(alice);
		vm.assume(alice != address(0));
		vm.assume(alice != address(token));
		vm.assume(alice != address(this));
		vm.assume(amount > 0);
		vm.assume(amount < MAX_INT);
		vm.assume(totalSupply > 0);
		vm.assume(totalSupply < MAX_INT);
		vm.assume(balanceAlice > 0);
		vm.assume(balanceAlice < MAX_INT);
		vm.assume((balanceAlice + amount) < MAX_INT);
		vm.assume((totalSupply + amount) < MAX_INT);
		vm.assume(balanceAlice < totalSupply);
		uint256 newSupply = (totalSupply + amount);
		uint256 newBalanceAlice = (balanceAlice + amount);
		token.mint(alice, amount);
		assertEq(token.balanceOf(alice), newBalanceAlice);
		assertEq(token.totalSupply(), newSupply);
		assert(alice != address(0));
		assert(alice != address(token));
		assert(alice != address(this));
		assert(amount > 0);
		assert(amount < MAX_INT);
		assert(newSupply > 0);
		assert(newSupply < MAX_INT);
		assert(newBalanceAlice > 0);
		assert(newBalanceAlice < MAX_INT);
		assert(newBalanceAlice < newSupply);
    }

    // function testMint1(address alice, uint256 amount) public { //passed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice > 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply > 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice < totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }

    // function testMint2(address alice, uint256 amount) public { //passed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice >= 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply > 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice < totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }

    // function testMint3(address alice, uint256 amount) public { //failed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice > 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply >= 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice < totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }

    // function testMint4(address alice, uint256 amount) public { //passed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice > 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply > 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice <= totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }

    // function testMint5(address alice, uint256 amount) public { //failed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice > 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply >= 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice <= totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }


    function testMintExtended(address alice, uint256 amount) public { //passed
    	kevm.infiniteGas();
		
		uint256 totalSupply = token.totalSupply();
		uint256 balanceAlice = token.balanceOf(alice);
		vm.assume(alice != address(0));
		vm.assume(alice != address(token));
		vm.assume(alice != address(this));
		vm.assume(totalSupply > 0);
		vm.assume((balanceAlice + amount) <= MAX_INT);
		vm.assume((totalSupply + amount) <= MAX_INT);
		vm.assume(balanceAlice <= totalSupply);
		uint256 newSupply = (totalSupply + amount);
		uint256 newBalanceAlice = (balanceAlice + amount);
		token.mint(alice, amount);
		assertEq(token.balanceOf(alice), newBalanceAlice);
		assertEq(token.totalSupply(), newSupply);
		assert(alice != address(0));
		assert(alice != address(token));
		assert(alice != address(this));
		assert(amount >= 0);
		assert(amount <= MAX_INT);
		assert(newSupply > 0);
		assert(newSupply <= MAX_INT);
		assert(newBalanceAlice >= 0);
		assert(newBalanceAlice < MAX_INT);
		assert(newBalanceAlice < newSupply);
    }


    // function testMint7(address alice, uint256 amount) public { //failed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice >= 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply >= 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice < totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }


    // function testMint8(address alice, uint256 amount) public { //failed
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(amount >= 0);
	// 	vm.assume(amount <= MAX_INT);
	// 	vm.assume(balanceAlice >= 0);
	// 	vm.assume(balanceAlice <= MAX_INT);
	// 	vm.assume(totalSupply >= 0);
	// 	vm.assume(totalSupply <= MAX_INT);
	// 	vm.assume((balanceAlice + amount) <= MAX_INT);
	// 	vm.assume((totalSupply + amount) <= MAX_INT);
	// 	vm.assume(balanceAlice <= totalSupply);
	// 	uint256 newSupply = (totalSupply + amount);
	// 	uint256 newBalanceAlice = (balanceAlice + amount);
	// 	token.mint(alice, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }

    // function testBurn(address alice, uint256 amount) public {
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(balanceAlice > amount);
	// 	vm.assume(totalSupply > amount);
	// 	vm.assume(balanceAlice < totalSupply);
	// 	uint256 newSupply = (totalSupply - amount);
	// 	uint256 newBalanceAlice = (balanceAlice - amount);
	// 	vm.prank(alice);
	// 	token.burn(amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), newSupply);
    // }

    // function testTransfer(address alice, address bob, uint256 amount) public {
    // 	kevm.infiniteGas();
		
	// 	uint256 totalSupply = token.totalSupply();
	// 	uint256 balanceAlice = token.balanceOf(alice);
	// 	uint256 balanceBob = token.balanceOf(bob);
	// 	vm.assume(alice != address(0));
	// 	vm.assume(alice != address(token));
	// 	vm.assume(alice != address(this));
	// 	vm.assume(bob != address(0));
	// 	vm.assume(bob != address(token));
	// 	vm.assume(bob != address(this));
	// 	vm.assume(amount > 0);
	// 	vm.assume(amount < MAX_INT);
	// 	vm.assume(totalSupply > 0);
	// 	vm.assume(totalSupply < MAX_INT);
	// 	vm.assume(balanceAlice > 0);
	// 	vm.assume(balanceAlice < MAX_INT);
	// 	vm.assume(balanceBob > 0);
	// 	vm.assume(balanceBob < MAX_INT);
	// 	vm.assume(balanceAlice > amount);
	// 	vm.assume(totalSupply > amount);
	// 	vm.assume((balanceBob + amount) < MAX_INT);
	// 	vm.assume((balanceAlice + balanceBob) < totalSupply);
	// 	uint256 newBalanceAlice = (balanceAlice - amount);
	// 	uint256 newBalanceBob = (balanceBob + amount);
	// 	vm.prank(alice);
	// 	token.transfer(bob, amount);
	// 	assertEq(token.balanceOf(alice), newBalanceAlice);
	// 	assertEq(token.totalSupply(), totalSupply);
    // }

    function testMintFailure(address alice, uint256 amount) public { //passed
    	kevm.infiniteGas();
		uint256 totalSupply = token.totalSupply();
		uint256 balanceAlice = token.balanceOf(alice);
		vm.assume(alice != address(0));
		vm.assume(alice != address(token));
		vm.assume(alice != address(this));
		vm.assume(amount >= 0);
		vm.assume(amount <= MAX_INT);
		vm.assume(balanceAlice >= 0);
		vm.assume(balanceAlice <= MAX_INT);
		vm.assume(totalSupply > 0);
		vm.assume(totalSupply <= MAX_INT);
		vm.assume((balanceAlice + amount) > MAX_INT);
		vm.assume((totalSupply + amount) > MAX_INT);
		vm.assume(balanceAlice <= totalSupply);

		vm.expectRevert(stdError.arithmeticError);
		token.mint(alice, amount);
    }
}
