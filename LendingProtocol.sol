
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LendingProtocol {

    address public owner;

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public loans;

    uint256 public interestRate = 5;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);
    event Repay(address indexed user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        deposits[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient deposited balance");

        deposits[msg.sender] -= amount;

        payable(msg.sender).transfer(amount);

        emit Withdraw(msg.sender, amount);
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Invalid amount");
        require(
            address(this).balance >= amount,
            "Insufficient funds in protocol"
        );

        loans[msg.sender] += amount;

        payable(msg.sender).transfer(amount);

        emit Borrow(msg.sender, amount);
    }

    function repay() external payable {
        require(loans[msg.sender] > 0, "No active loan");
        require(msg.value > 0, "Repayment must be greater than zero");

        if (msg.value >= loans[msg.sender]) {
            loans[msg.sender] = 0;
        } else {
            loans[msg.sender] -= msg.value;
        }

        emit Repay(msg.sender, msg.value);
    }

    function calculateInterest(address borrower)
        public
        view
        returns (uint256)
    {
        return (loans[borrower] * interestRate) / 100;
    }

    function totalDebt(address borrower)
        public
        view
        returns (uint256)
    {
        return loans[borrower] + calculateInterest(borrower);
    }

    function updateInterestRate(uint256 newRate)
        external
        onlyOwner
    {
        interestRate = newRate;
    }

    function contractBalance()
        public
        view
        returns (uint256)
    {
        return address(this).balance;
    }
}
