// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBeerToken {

    // * Default attributes of your token.
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);

    // * Our BeerToken is not divisible.
    function decimals() external view returns (uint8);

    // * Show the total supply of tokens
    function totalSupply() external view returns (uint256);
    // * Show the token balance of the address
    function balanceOf(address who) external view returns (uint256);

    // * Basic functionality for transferring tokens to user.
    //   The token contract keeps track of the token balances.
    // * Token must not be lost! Make sure they can only be transferred to addresses,
    //   who also support the receiving of tokens.
    function transfer(address to, uint256 value) external returns (bool success);
    function transfer(address to, uint256 value, bytes calldata data) external returns (bool success);

    // * Tokens can be minted by the owner of the token contract.
    function mint(address account, uint256 value) external returns (bool success);

    // * Tokens can be burned and therefore "destroyed".
    function burn(uint256 value) external;

    // * Everytime a token is transferred/balances changed, this event has to be emitted.
    event Transfer(address indexed from, address indexed to, uint256 value);
}