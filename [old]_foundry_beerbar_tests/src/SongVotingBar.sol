// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BeerBar.sol";
import "./Roles.sol";

contract SongVotingBar is BeerBar {
    using Roles for Roles.Role;

    Roles.Role private _dj;

    bool private _voting_open;
    uint256 _voting_round;
    mapping (uint256 => mapping (string => uint256)) private _votes;
    mapping (uint256 => mapping (address => bool)) private _voted;

    struct Song {
        string title;
        uint votes;
    }

    Song private _winner;

    constructor () {
        _winner = Song("No Song.", 0);
        _voting_open = false;
        _voting_round = 0;
    }

    event DjAdded(address account);
    event DjRemoved(address account);
    event VotingStarted();
    event VotingClosed(string winner);
    event SongVote(string song_title);

    function isDj(address account) external view returns (bool) {
        return _dj.has(account);
    }
    function addDj(address account) external {
        require(_owner.has(msg.sender), "Only owner can set dj!");
        _dj.add(account);
        emit DjAdded(account);
    }
    function renounceDj() external {
        require(_dj.has(msg.sender), "Has to be dj!");
        _dj.remove(msg.sender);
        emit DjRemoved(msg.sender);
    }

    function startVoting() external {
        if (!_dj.has(msg.sender)) revert();
        require(!_voting_open, "The voting is open");
        require(_bar_open, "The bar is not open");
        _voting_round++;
        _winner = Song("No Song", 0);
        _voting_open = true;
        emit VotingStarted();
    }

    function endVoting() external {
        if (!_dj.has(msg.sender)) revert();
        require(_voting_open, "The voting is not open");
        _voting_open = false;
        emit VotingClosed(_winner.title);
    }

    function votingIsOpen() external view returns (bool) {
        return _voting_open;
    }

    function closeBar() external override (BeerBar) {
        require(_barkeeper.has(msg.sender) || _dj.has(msg.sender), "The bar is opened and closed by bar keepers or djs.");
        require(_bar_open, "The bar is not open");
        _bar_open = false;
        if (_voting_open) emit VotingClosed(_winner.title);
        _voting_open = false;
        emit BarClosed();
    }

    function getWinner() external view returns (string memory) {
        require(!_voting_open, "The voting is still in process");
        return _winner.title;
    }

    function vote(string memory song_title) external payable {
        require(_voting_open, "The voting is not open");
        if(_voted[_voting_round][msg.sender]) revert();
        _votes[_voting_round][song_title]++;
        _voted[_voting_round][msg.sender] = true;

        if(keccak256(abi.encodePacked(_winner.title)) != keccak256(abi.encodePacked(song_title))
            && _winner.votes <= _votes[_voting_round][song_title]) {
            _winner = Song(song_title, _votes[_voting_round][song_title]);
        } else {
            _winner.votes++;
        }

        emit SongVote(song_title);
        _buyToken();
    }
}
