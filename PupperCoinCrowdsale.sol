pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

//  Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        address payable wallet,
        uint goal,
        uint rate,
        PupperCoin token,
        uint openTime,
        uint closeTime
        )
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(openTime, closeTime)
        RefundableCrowdsale(goal)
        public {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {
    // Instantiate variables
    address public tokenSaleAddress;
    address public tokenAddress;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet) public {
        // Create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        tokenAddress = address(token);

        // Create the PupperCoinSale and tell it about the token, set the goal = 300, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale tokenSale = new PupperCoinSale(wallet, 300, 1, token, now, now + 24 weeks);
        tokenSaleAddress = address(tokenSale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(tokenSaleAddress);
        token.renounceMinter();
    }
}
