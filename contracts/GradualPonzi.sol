pragma solidity ^0.5.0;

contract GradualPonzi {
    // set up two state variables and a constant
    address[] public investors;
    mapping (address => uint) public balances;
    uint public constant MINIMUM_INVESTMENT = 1e15; // 0.001 e

    constructor() public {
        // message sender is the first investor (who also doesn't have to send a min)
        investors.push(msg.sender);
    }

    function () external payable {
        require(msg.value >= MINIMUM_INVESTMENT, "Investment below minimum");
        uint investorCut = msg.value / investors.length;
        for(uint i = 0; i < investors.length; i++) {
            balances[investors[i]] += investorCut;
        }
        // msg sender comes in with 0 amount,
        // his investments is dispursed across the other ones
        investors.push(msg.sender);
    }

    // because more payout to handle, better to use a withdrawal function, 'on-demand'
    // and an internal balance
    // preventing 'freeloaders' by imposing minimum investment
    function withdraw() external {
        uint payout = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(payout);
    }
}