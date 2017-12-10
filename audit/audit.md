# Streamity crowdsale smart contracts audit.

Status - in work.

## General

The contract code is checked for critical errors to lead to a loss of money by investors.

* There are critical errors in the StreamityCrowdsale contract, because of which the code will not work as expected: if the minimum investment value is set to 0.1 ether, the contract will not accept an amount less than 1 ether.

* There is a possibility of sending tokens before the end of the ICO. The presence of bonus periods allows holders to sell previously purchased tokens during the ICO at a price lower than in the contract.

Streamity tokens crowdsale through the StreamityContract contract, it inherits the functionality of Token ERC20 and ERC20Extending token contracts, the StreamityCrowdsale sales contract, and also Ownable, which implements the contract ownership mechanism and Pauseble, which allows contract owner to put a token sale on a pause. Some contracts use the MathLib library methods for secure computing.

## Contracts review

TokenERC20

1) (Note) All the emission of tokens is indicated at the time of the contract's deploy, additional emission is not provided.
2) (Note) A token contract mint coins to his own address.
3) (Minor) Redundant operation in the constructor: owner = msg.sender
4) (Medium) The SafeMath library is connected, but in most operations it is not used
5) (Important) There are no restrictions on sending (buying / selling) tokens for the ICO period (in this ICO discount periods are provided, the buyer can buy tokens with a discount and resell them profitably for the following periods at a lower, than the price set in the contract.
6) (Note) Coins can be burned only by the owner of the contract from their own balance or from the holder's balance, which allowed the owner of the contract to spend the appropriate number of tokens from his account.

ERC20Extending

1) (Note) A contract owner can send any available count of ethers from the balance of the contract to any address
2) (Note) A contract owner can send any available count of tokens from the balance of the contract to any address

Pauseble

1) (Note) The contract contains a functional allowing its owner to switch the trigger paused in the on and off position and modifiers allowing the calling of certain functions only in pause mode or only in the mode outside the pause.
2) (Minor) The variable startIcoDate is declared, but not used in this contract: it is more appropriate to declare it in the contract where it is used directly

StreamityCrowdsale

1) (Critical) The function "sell" does not allow selling the token for less than 1 ether due to incorrect recording of the operations.
2) (Minor) The SafeMath library is connected, but not used everywhere.
3) (Note) A contract owner can change the cost of selling a token by contract.
4) (Minor) The crowdSaleStatus function returns the string value of the sale status, in most cases it is optimal to encode the encoded numerical value for saving gas.
5) (Note) The function "sell" is responsible for sending tokens to the specified address, the initial number of tokens is transferred by the function parameter, then according to the current sales period, the count of tokens calculated with additional bonus, and sent to the address specified by the parameter.
6) (Note) Bonus tokens are provided only for the first, second and third period of the tokensale. On the first day of the second period an additional bonus is provided: its value in the case of equality 0 is increased to 20% of the number of sent tokens.
7) (Average) Each sale phase starts with the call to the startCrowd function by the contract owner only, the previous stage ends either after the number of days specified in the _endDate parameter of the startCrowd function, or the next time it is called startCrowd.

StreamityContract

1) (Important) In the function responsible for receiving ethers, a minimum transaction is 0.1 ethers, but when trying to send a ethers for an amount less than 1, there will be an error in the "sell" function.
2) (Not critical) I recommend adding a public variable to the contract, which shows how many all the ethers have collected the contract. This variable will allow you to track how much all the money collected through the contract and display this information in dapp. (added).

MathLib

1) (Not critical) Using the require operator instead of assert will save gas in case of erroneous calculations in contract methods.

The Migrations contract is not related to other contracts.

## Disclaimer

This audit concerns only the correctness of the Smart Contracts listed, and is not to be taken as an endorsement of the platform, team, or company.

## Autors

The audit was provided by Vyacheslav Poskonin - https://github.com/EthereumWorks/, please contact: Telegram - @SlavaPoe, Skype - v.poskonin (MousePo).
