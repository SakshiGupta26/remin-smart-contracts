// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value)
        external
        returns (bool);

    function transferFrom(address from, address to, uint256 value)
        external
        returns (bool);
}

contract LearningToken is IERC20 {

    string public name = "Learning Token";
    string public symbol = "LRN";
    uint8 public decimals = 18;

    uint256 public override totalSupply = 1000 * 10 ** 18;

    address public founder;

    mapping(address => uint256) public balanceOfUser;

    mapping(address => mapping(address => uint256))
        public allowedTokens;

    constructor() {
        founder = msg.sender;
        balanceOfUser[founder] = totalSupply;
    }

    function balanceOf(address account)
        external
        view
        override
        returns (uint256)
    {
        return balanceOfUser[account];
    }

    function transfer(address to, uint256 value)
        external
        override
        returns (bool)
    {
        require(to != address(0), "Invalid address");
        require(balanceOfUser[msg.sender] >= value,
            "Insufficient balance");

        balanceOfUser[msg.sender] -= value;
        balanceOfUser[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        override
        returns (uint256)
    {
        return allowedTokens[owner][spender];
    }

    function approve(address spender, uint256 value)
        external
        override
        returns (bool)
    {
        require(spender != address(0), "Invalid address");

        allowedTokens[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    )
        external
        override
        returns (bool)
    {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");

        require(balanceOfUser[from] >= value,
            "Insufficient balance");

        require(
            allowedTokens[from][msg.sender] >= value,
            "Allowance exceeded"
        );

        allowedTokens[from][msg.sender] -= value;

        balanceOfUser[from] -= value;
        balanceOfUser[to] += value;

        emit Transfer(from, to, value);

        return true;
    }
}
