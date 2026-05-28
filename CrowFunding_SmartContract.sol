// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract CrowdFunding {
    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(address => uint) public contributors;
    mapping(uint => Request) public requests;
    uint public numRequests;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;
    bool private locked;

    constructor(uint _target, uint _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "You are not the manager");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrancy guard");
        locked = true;
        _;
        locked = false;
    }

    function createRequest(string calldata _description, address payable _recipient, uint _value)
        public
        onlyManager
    {
        Request storage newRequest = requests[numRequests];
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
        numRequests++;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value >= minimumContribution, "Minimum Contribution Required is 100 wei");
        if (contributors[msg.sender] == 0) {
            noOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function refund() public nonReentrant {
        require(block.timestamp > deadline && raisedAmount < target,
            "You are not eligible for refund");
        require(contributors[msg.sender] > 0, "You are not a contributor");
        uint amount = contributors[msg.sender];
        contributors[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "You are not a contributor");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false, "You have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyManager nonReentrant {
        Request storage thisRequest = requests[_requestNo];
        require(raisedAmount >= target, "Target is not reached");
        require(thisRequest.noOfVoters > noOfContributors / 2,
            "Majority does not support the request");
        require(!thisRequest.completed, "Request already completed");

        (bool success, ) = thisRequest.recipient.call{value: thisRequest.value}("");
        require(success, "Payment failed");
        thisRequest.completed = true;
    }
}
