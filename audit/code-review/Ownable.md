// EW Ok
pragma solidity ^0.4.18;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
// EW Ok
contract Ownable
{
    // EW Ok
    address public owner;

    // EW Ok
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    // EW Ok - Constructor 
    function Ownable() public {
        // EW Ok
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
     // EW Ok
    modifier onlyOwner() {
        // EW Ok
        require(msg.sender == owner);
        // EW Ok
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
     // EW Ok - Only owner can execute
    function transferOwnership(address newOwner) public onlyOwner {
        // EW Ok
        require(newOwner != address(0));
        // EW Ok - first you need to change the owner, and then announce the event
        OwnershipTransferred(owner, newOwner);
        // EW Ok
        owner = newOwner;
    }
}
