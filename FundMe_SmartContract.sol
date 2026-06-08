
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundMe {
    address public immutable owner;
    uint256 public constant MINIMUM_CONTRIBUTION = 0.01 ether;

    mapping(address => uint256) public contributions;
    address[] public funders;

    event Funded(address indexed funder, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function fund() external payable {
        require(
            msg.value >= MINIMUM_CONTRIBUTION,
            "Minimum contribution not met"
        );

        if (contributions[msg.sender] == 0) {
            funders.push(msg.sender);
        }

        contributions[msg.sender] += msg.value;

        emit Funded(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;

        for (uint256 i = 0; i < funders.length; i++) {
            contributions[funders[i]] = 0;
        }

        delete funders;

        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Transfer failed");

        emit Withdrawn(owner, balance);
    }

    function getFunders() external view returns (address[] memory) {
        return funders;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
