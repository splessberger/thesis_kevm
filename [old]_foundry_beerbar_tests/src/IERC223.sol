pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC223 standard token as defined in the EIP.
 */

interface IERC223 {

    function name()        external view returns (string memory);
    function symbol()      external view returns (string memory);
    function standard()    external view returns (string memory);
    function decimals()    external view returns (uint8);
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the balance of the `who` address.
     */
    function balanceOf(address who) external view returns (uint);

    /**
     * @dev Transfers `value` tokens from `msg.sender` to `to` address
     * and returns `true` on success.
     */
    function transfer(address to, uint value) external returns (bool success);

    /**
     * @dev Transfers `value` tokens from `msg.sender` to `to` address with `data` parameter
     * and returns `true` on success.
     */
    function transfer(address to, uint value, bytes calldata data) external returns (bool success);

     /**
     * @dev Additional event that is fired on successful transfer and logs transfer metadata,
     *      this event is implemented to keep Transfer event compatible with ERC20.
     */
    event TransferData(bytes data);
}
