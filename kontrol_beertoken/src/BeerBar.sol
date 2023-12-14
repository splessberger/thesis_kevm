// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBeerBar.sol";
import "./BeerToken.sol";
import "./IERC223Recipient.sol";
import "./Roles.sol";

contract BeerBar is IBeerBar, IERC223Recipient  {
    using Roles for Roles.Role;

    Roles.Role internal _owner;
    Roles.Role internal _barkeeper;

    BeerToken private beerTokenContract;

    bool internal _bar_open;

    mapping(address => uint256) private _orders;

    uint256 _beer_price;

    constructor () {
        _bar_open = false;
        _beer_price = 10000000;
        _owner.add(msg.sender);
    }

    function isOwner(address account) external view returns (bool) {
        return _owner.has(account);
    }
    function addOwner(address account) external {
        require(_owner.has(msg.sender), "Only owner can set owner!");
        _owner.add(account);
        emit OwnerAdded(account);
    }
    function renounceOwner() external {
        require(_owner.has(msg.sender), "Has to be owner!");
        _owner.remove(msg.sender);
        emit OwnerRemoved(msg.sender);
    }

    function isBarkeeper(address account) external view returns (bool) {
        return _barkeeper.has(account);
    }
    function addBarkeeper(address account) external {
        require(_owner.has(msg.sender), "Only owner can set barkeeper!");
        _barkeeper.add(account);
        emit BarkeeperAdded(account);
    }
    function renounceBarkeeper() external {
        require(_barkeeper.has(msg.sender), "Has to be barkeeper!");
        _barkeeper.remove(msg.sender);
        emit BarkeeperRemoved(msg.sender);
    }

    function setBeerTokenContractAddress(address _address) external {
        require(_owner.has(msg.sender), "Only owner can set token address!");
        beerTokenContract = BeerToken(_address);
    }

    function beerTokenContractAddress() external view returns(address) {
        return address(beerTokenContract);
    }

    function openBar() external {
        require(_barkeeper.has(msg.sender), "The bar is opened and closed by bar keepers.");
        require(!_bar_open, "The bar is not closed");
        _bar_open = true;
        emit BarOpened();
    }

    function closeBar() virtual external {
        require(_barkeeper.has(msg.sender), "The bar is opened and closed by bar keepers.");
        require(_bar_open, "The bar is not open");
        _bar_open = false;
        emit BarClosed();
    }

    function barIsOpen() external view returns (bool) {
        return _bar_open;
    }

    function tokenReceived(address _from, uint _value, bytes memory _data) public virtual override (IERC223Recipient) {
        if (keccak256(abi.encodePacked(_data)) == keccak256(abi.encodePacked("supply"))) {
            if (!_owner.has(_from)) revert();
            emit BeerSupplied(_from, _value);
        }
        else if (keccak256(abi.encodePacked(_data)) == keccak256(abi.encodePacked(hex"00000000"))) {
            if (!_bar_open) revert();
            if (msg.sender != address(beerTokenContract)) revert();
            _orders[_from] += _value;
            emit BeerOrdered(_from, _value);
        } else {
            revert();
        }
    }

    function serveBeer(address customer, uint amount) external {
        require(_barkeeper.has(msg.sender), "Beer can only be served by barkeepers.");
        require(_bar_open, "Bar is closed.");
        require(amount <= _orders[customer], "More beers then ordered.");
        _orders[customer] -= amount;
        beerTokenContract.burn(amount);
    }

    function cancelOrder(uint amount) external {
        require(amount <= _orders[msg.sender], "More beers then ordered.");
        _orders[msg.sender] -= amount;
        beerTokenContract.transfer(msg.sender, amount);
        emit BeerCanceled(msg.sender, amount);
    }

    function pendingBeer(address _addr) external view returns (uint256) {
        return _orders[_addr];
    }

    function setBeerPrice(uint256 _price) external {
        require(_owner.has(msg.sender), "Beer price can only be changed by bar owner");
        require(!_bar_open, "Beer price can only be changed when the bar is closed.");
        _beer_price = _price;
    }
    function getBeerPrice() external view returns(uint256) {
        return _beer_price;
    }

    function buyToken() external payable {
        _buyToken();
    }

    function _buyToken() internal {
        uint256 tip = msg.value % _beer_price;
        uint256 amount = (msg.value - tip) / _beer_price;
        beerTokenContract.transfer(msg.sender, amount);
    }

    function payout(address payable _receiver, uint256 _amount) external {
        require(_owner.has(msg.sender), "Only bar owner may withdraw.");
        require(_amount <= address(this).balance, "Trying to withdraw too much.");
        _receiver.transfer(_amount);
    }
}
