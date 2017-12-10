1) (Note) A contract owner can send any available count of ethers from the balance of the contract to any address
2) (Note) A contract owner can send any available count of tokens from the balance of the contract to any address

// EW Ok
pragma solidity ^0.4.18;
// EW Ok
import "./TokenERC20.sol";

// EW Ok
contract ERC20Extending is TokenERC20
{
    /**
    * Function for transfer ethereum from contract to any address
    *
    * @param _to - address of the recipient
    * @param amount - ethereum
    */
    // EW Ok
    function transferEthFromContract(address _to, uint amount) public onlyOwner
    {
        // EW Ok
        _to.transfer(amount);
    }

    /**
    * Function for transfer tokens from contract to any address
    *
    */
    // EW Ok
    function transferTokensFromContract(address _to, uint256 _value) public onlyOwner
    {   
        // EW Ok
        avaliableSupply -= _value;
        // EW Ok
        _transfer(this, _to, _value);
    }
}
