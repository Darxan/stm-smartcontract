1) (Note) All the emission of tokens is indicated at the time of the contract's deploy, additional emission is not provided.
2) (Note) A token contract mint coins to his own address.
3) (Minor) Redundant operation in the constructor: owner = msg.sender
4) (Medium) The SafeMath library is connected, but in most operations it is not used
5) (Important) There are no restrictions on sending (buying / selling) tokens for the ICO period (in this ICO discount periods are provided, the buyer can buy tokens with a discount and resell them profitably for the following periods at a lower, than the price set in the contract.
6) (Note) Coins can be burned only by the owner of the contract from their own balance or from the holder's balance, which allowed the owner of the contract to spend the appropriate number of tokens from his account.

// EW Ok
pragma solidity ^0.4.18;
// EW Ok
import "./MathLib.sol";
// EW Ok
import "./Ownable.sol";

// EW Ok
interface tokenRecipient
{
    // EW Ok
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
}

// EW Ok
contract TokenERC20 is Ownable
{
    // EW Ok
    using SafeMath for uint;

    // Public variables of the token
    // EW Ok
    string public name;
    // EW Ok
    string public symbol;
    // EW Ok
    uint256 public decimals = 18;
    // EW Ok
    uint256 DEC = 10 ** uint256(decimals);
    // EW Ok - owner address of token contract is public
    address public owner;

    // 18 decimals is the strongly suggested default, avoid changing it
    // EW Ok
    uint256 public totalSupply;
    // EW Ok
    uint256 public avaliableSupply;
    // EW Ok token buy price - 1 ether
    uint256 public buyPrice = 1000000000000000000 wei;

    // This creates an array with all balances
    // EW Ok
    mapping (address => uint256) public balanceOf;
    // EW Ok
    mapping (address => mapping (address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    // EW Ok
    event Transfer(address indexed from, address indexed to, uint256 value);
    // EW Ok
    event Burn(address indexed from, uint256 value);
    // EW Ok
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
     // EW Ok 
    function TokenERC20(
        // EW Ok - token count without decimal part
        uint256 initialSupply,
        // EW Ok
        string tokenName,
        // EW Ok
        string tokenSymbol
    // EW Ok
    ) public
    {
        // EW Ok 
        totalSupply = initialSupply * DEC;  // Update total supply with the decimal amount
        // EW Ok 
        balanceOf[this] = totalSupply;                // Give the creator all initial tokens
        // EW Ok 
        avaliableSupply = balanceOf[this];            // Show how much tokens on contract
        // EW Ok 
        name = tokenName;                                   // Set the name for display purposes
        // EW Ok 
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        // EW Ok - this operation duplicates the operation of the constructor of the Ownavle contract
        owner = msg.sender;
    }

    /**
     * Internal transfer, only can be called by this contract
     *
     * @param _from - address of the contract
     * @param _to - address of the investor
     * @param _value - tokens for the investor
     */
     // EW Ok
    function _transfer(address _from, address _to, uint256 _value) internal
    {
        // Prevent transfer to 0x0 address. Use burn() instead
        // EW Ok
        require(_to != 0x0);
        // Check if the sender has enough
        // EW Ok
        require(balanceOf[_from] >= _value);
        // Check for overflows
        // EW Ok 
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Save this for an assertion in the future
        // EW Ok
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        // EW Ok
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        // EW Ok
        balanceOf[_to] += _value;
        // EW Ok - declare an event only after the operation is successfully completed
        Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        // EW Ok - Could use `require(...)` instead of `assert(...)` to save of gas in the case of an error
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
     // EW Ok
    function transfer(address _to, uint256 _value) public
    {
        // EW Ok
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` in behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
     // EW Ok
    function transferFrom(address _from, address _to, uint256 _value) public
        returns (bool success)
    {
        // EW Ok
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        // EW Ok
        allowance[_from][msg.sender] -= _value;
        // EW Ok
        _transfer(_from, _to, _value);
        // EW Ok
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
     // EW Ok
    function approve(address _spender, uint256 _value) public
        returns (bool success)
    {
        // EW Ok
        allowance[msg.sender][_spender] = _value;
        // EW Ok
        return true;
    }

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
     // EW Ok
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner
        returns (bool success)
    {
        // EW Ok
        tokenRecipient spender = tokenRecipient(_spender);
        // EW Ok - function approve always returns true and never false
        if (approve(_spender, _value)) {
            // EW Ok
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            // EW Ok
            return true;
        }
    }

    /**
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     */
     // EW Ok
    function increaseApproval (address _spender, uint _addedValue) public
        returns (bool success)
    {
        // EW 
        allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
        // EW Ok
        Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        // EW Ok
        return true;
    }

    // EW Ok
    function decreaseApproval (address _spender, uint _subtractedValue) public
        returns (bool success)
    {
        // EW Ok
        uint oldValue = allowance[msg.sender][_spender];
        // EW Ok
        if (_subtractedValue > oldValue) {
            // EW Ok
            allowance[msg.sender][_spender] = 0;
        // EW Ok    
        } else {
            // EW Ok
            allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        // EW Ok
        Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
        // EW Ok
        return true;
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
     // EW Ok - burning tokens can be made by the owner of contract from his own account
    function burn(uint256 _value) public onlyOwner
        returns (bool success)
    {
        // EW Ok
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough

        // EW Ok
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        // EW Ok
        totalSupply -= _value;                      // Updates totalSupply
        // EW Ok
        avaliableSupply -= _value;
        // EW Ok
        Burn(msg.sender, _value);
        // EW Ok
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
     // EW Ok - burning tokens can be made by the owner of contract from holders who allow spend tokens from their account
    function burnFrom(address _from, uint256 _value) public onlyOwner
        returns (bool success)
    {
        // EW Ok
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        // EW Ok
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        // EW Ok
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        // EW Ok
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        // EW Ok
        totalSupply -= _value;                              // Update totalSupply
        // EW Ok
        avaliableSupply -= _value;
        // EW Ok
        Burn(_from, _value);
        // EW Ok
        return true;
    }
}
