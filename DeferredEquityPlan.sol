pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

// lvl 3: equity plan
contract DeferredEquityPlan {
    using SafeMath for uint;
    address human_resources;
    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract
    uint fakenow = now;

    // @TODO: Set the total shares and annual distribution
    // Your code here!
    uint public total_shares = 1000;
    uint public annual_distribution = 250;

    uint start_time = now; // permanently store the time this contract was initialized

    // @TODO: Set the `unlock_time` to be 365 days from now
    // Your code here!
    uint unlock_time = fakenow.add(365 days);

    uint public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        // @TODO: Add "require" statements to enforce that:
        // 1: `unlock_time` is less than or equal to `now`
        // 2: `distributed_shares` is less than the `total_shares`
        // Your code here!
        
        require(unlock_time <= fakenow, "This contract is not available at this time!");
        require(distributed_shares <= total_shares, "Not enough shares!");

        // @TODO: Add 365 days to the `unlock_time`
        // Your code here!
        
        unlock_time = unlock_time.add(365 days);

        // @TODO: Calculate the shares distributed by using the function (now - start_time) / 365 days * the annual distribution
        // Make sure to include the parenthesis around (now - start_time) to get accurate results!
        // Your code here!
        
        distributed_shares = ((fakenow.sub(start_time)).div(365 days)).mul(annual_distribution); 

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }
    
    function fastforward() public {
    fakenow += 200 days;
    }


    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
