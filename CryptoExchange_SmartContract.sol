// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CryptoExchange_SmartContract {
    address public owner;

    mapping(address => uint256) public ethBalance;
    mapping(address => mapping(address => uint256)) public tokenBalance;

    event DepositETH(address indexed user, uint256 amount);
    event WithdrawETH(address indexed user, uint256 amount);
    event DepositToken(address indexed user, address indexed token, uint256 amount);
    event WithdrawToken(address indexed user, address indexed token, uint256 amount);
    event Trade(
        address indexed buyer,
        address indexed seller,
        address indexed token,
        uint256 tokenAmount,
        uint256 ethAmount
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function depositETH() external payable {
        require(msg.value > 0, "Amount must be greater than zero");

        ethBalance[msg.sender] += msg.value;

        emit DepositETH(msg.sender, msg.value);
    }

    function withdrawETH(uint256 amount) external {
        require(ethBalance[msg.sender] >= amount, "Insufficient ETH balance");

        ethBalance[msg.sender] -= amount;

        payable(msg.sender).transfer(amount);

        emit WithdrawETH(msg.sender, amount);
    }

    function depositToken(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        require(
            IERC20(token).transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );

        tokenBalance[msg.sender][token] += amount;

        emit DepositToken(msg.sender, token, amount);
    }

    function withdrawToken(address token, uint256 amount) external {
        require(
            tokenBalance[msg.sender][token] >= amount,
            "Insufficient token balance"
        );

        tokenBalance[msg.sender][token] -= amount;

        require(
            IERC20(token).transfer(msg.sender, amount),
            "Token transfer failed"
        );

        emit WithdrawToken(msg.sender, token, amount);
    }

    function trade(
        address buyer,
        address seller,
        address token,
        uint256 tokenAmount,
        uint256 ethAmount
    ) external onlyOwner {
        require(
            ethBalance[buyer] >= ethAmount,
            "Buyer has insufficient ETH"
        );

        require(
            tokenBalance[seller][token] >= tokenAmount,
            "Seller has insufficient tokens"
        );

        ethBalance[buyer] -= ethAmount;
        ethBalance[seller] += ethAmount;

        tokenBalance[seller][token] -= tokenAmount;
        tokenBalance[buyer][token] += tokenAmount;

        emit Trade(buyer, seller, token, tokenAmount, ethAmount);
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}
