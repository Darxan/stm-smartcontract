1) (Note) The contract contains a functional allowing its owner to switch the trigger paused in the on and off position and modifiers allowing the calling of certain functions only in pause mode or only in the mode outside the pause.
2) (Minor) The variable startIcoDate is declared, but not used in this contract: it is more appropriate to declare it in the contract where it is used directly

// EW Ok
pragma solidity ^0.4.18;
// EW Ok
import "./TokenERC20.sol";

// EW Ok
contract Pauseble is TokenERC20
{
    // EW Ok
    event EPause();
    // EW Ok
    event EUnpause();

    // EW Ok
    bool public paused = true;
    // EW Ok - announced, but in this contract is not used in any way
    uint public startIcoDate = 0;

    // EW Ok
    modifier whenNotPaused()
    {
      // EW Ok  
      require(!paused);
      // EW Ok
      _;
    }

    // EW Ok
    modifier whenPaused()
    {   
          // EW Ok  
          require(paused);
        // EW Ok
        _;
    }

    // EW Ok
    function pause() public onlyOwner
    {
        // EW Ok
        paused = true;
        // EW Ok
        EPause();
    }

    // EW Ok
    function pauseInternal() internal
    {
        // EW Ok
        paused = true;
        // EW Ok
        EPause();
    }

    // EW Ok
    function unpause() public onlyOwner
    {
        // EW Ok
        paused = false;

        // EW Ok
        EUnpause();
    }
}
