// EW Ok
pragma solidity ^0.4.18;

// EW - Could use `require(...)` instead of `assert(...)` to save of gas in the case of an error
// EW Ok
library SafeMath
{   
    // EW Ok
    function mul(uint256 a, uint256 b) internal pure
        returns (uint256)
    
    {
        // EW Ok
        uint256 c = a * b;

        // EW Ok
        assert(a == 0 || c / a == b);

        // EW Ok
        return c;
    }

    // EW Ok
    function div(uint256 a, uint256 b) internal pure
        returns (uint256)
    {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // EW Ok
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        // EW Ok
        return c;
    }

    // EW Ok
    function sub(uint256 a, uint256 b) internal pure
        returns (uint256)
    {
        // EW Ok
        assert(b <= a);

        // EW Ok
        return a - b;
    }

    // EW Ok
    function add(uint256 a, uint256 b) internal pure
        returns (uint256)
    {
        // EW Ok
        uint256 c = a + b;

        // EW Ok
        assert(c >= a);

        // EW Ok
        return c;
    }
}
