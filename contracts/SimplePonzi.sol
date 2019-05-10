pragma solidity ^0.5.0;

contract SimplePonzi {
    // if no one ever tops the bid of 'currentInvestor',
    // they will be the one to lose the investment
    address payable currentInvestor;
    // the investment they stand to lose
    uint public currentInvestment = 0;

    // payable callback function; gets executed by directly
    // sending ether to the contract
    function () external payable {
        // new investments must be 10% greater than current, current * 1.1 (expressed in fraction)
        uint minimumInvestment = (currentInvestment * 11) / 10;
        require(msg.value > minimumInvestment, "Investment must meet the minimum requirement of 0.001 ether.");

        // document new investor
        address payable previousInvestor = currentInvestor;
        currentInvestor = msg.sender;
        currentInvestment = msg.value;

        // payout previous investor

        // .transfer would allow anyone to block our contract
        // send forwards only 2300 gas stipend, so we are safe from re-entrancy attack
        // detering the attackers by imposing a monetary penalty for attempting a malicious tx
        // developers get penalized for their errors (after all, security is paramount)
        previousInvestor.send(msg.value);
    }
}