// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/BeerToken.sol";
import "../src/utils/KEVMCheats.sol";
import "forge-std/Test.sol";

contract BeerTokenTest is Test, KEVMCheats {
    uint256 constant MAX_INT = 2**256 - 1;
    bytes32 constant BALANCES_STORAGE_INDEX = 0;
    BeerToken token; // Contract under test

    modifier symbolic() {
        kevm.infiniteGas();
        kevm.symbolicStorage(address(token));
        _;
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

    function setUp() public {
        token = new BeerToken();
    }
    
    function testDecimals(bytes32 storageSlot)
      public
      unchangedStorage(storageSlot) {
        assertEq(token.decimals(), '0');
    }

    function testTransfer(address alice, address bob, uint256 amount, bytes32 storageSlot)
      public
      symbolic
      unchangedStorage(storageSlot)
      {
        bytes32 storageLocationAlice = hashedLocation(alice, BALANCES_STORAGE_INDEX);
        bytes32 storageLocationBob = hashedLocation(bob, BALANCES_STORAGE_INDEX);
        //I'm expecting the storage to change for _balances[alice] and _balances[bob]
        vm.assume(storageLocationAlice != storageSlot);
        vm.assume(storageLocationBob != storageSlot);
        vm.assume(alice != address(0));
        vm.assume(bob != address(0));
        vm.assume(alice != bob);
        vm.assume(storageLocationAlice != storageLocationBob);
        uint256 balanceAlice = token.balanceOf(alice);
        uint256 balanceBob = token.balanceOf(bob);
        vm.assume(balanceAlice >= amount);
        vm.assume(balanceBob <= MAX_INT - amount);
        vm.startPrank(alice);
        token.transfer(bob, amount);
        assertEq(token.balanceOf(alice), balanceAlice - amount);
        assertEq(token.balanceOf(bob), balanceBob + amount);
    }
}
