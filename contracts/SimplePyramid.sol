pragma solidity ^0.5.0;

contract SimplePyramid {
    // sending more than the minimum is not advised & does not make sense
    uint public constant MINIMUM_INVESTMENT = 1e16;
    // a running internal count of number of investors that have invested thus far
    uint public numInvestors = 0;
    // current pyramid level
    uint public depth = 0;
    // array contatining all investors (IN ORDER!)
    address[] public investors;
    // internal legdger
    mapping(address => uint) public balances;

    constructor() public payable {
        require(msg.value >= MINIMUM_INVESTMENT, "Investment must meet the minimum requirement of 0.01 ether.");
        investors.length = 3; // dynamically updating the array length
        investors[0] = msg.sender;
        numInvestors = 1;
        depth = 1;
        balances[address(this)] = msg.value; // (?)
    }

    function () external payable {
        require(msg.value >= MINIMUM_INVESTMENT, "Investment must meet the minimum requirement of 0.01 ether.");
        balances[address(this)] += msg.value;

        numInvestors += 1;
        // or investors.push(msg.sender)
        investors[numInvestors - 1] = msg.sender;

        // if we filled this pyramid layer, trigger payout
        if(numInvestors == investors.length) {
            // pay out previous layer
            uint endIndex = numInvestors - 2**depth;
            uint startIndex = endIndex - 2**(depth - 1);

            for (uint i = startIndex; i < endIndex; i++) {
                balances[investors[i]] += MINIMUM_INVESTMENT;
            }

            // spreaad remaining ether among all participants
            uint paid = MINIMUM_INVESTMENT * 2**(depth - 1);
            uint investorCut = (balances[address(this)] - paid) / numInvestors;
            for(uint i = 0; i < numInvestors; i++) {
                balances[investors[i]] += investorCut;
            }

            // update state variables
            balances[address(this)] = 0;
            depth += 1;
            investors.length += 2**depth;
        }
    }

    function withdraw() external {
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}