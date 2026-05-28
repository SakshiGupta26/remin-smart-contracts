// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReminToken {

    string public name = "Remin Token";
    string public symbol = "RMT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool) {

    }

    function approve(address spender, uint256 value) public returns (bool) {

    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {

    }

    function mint(address to, uint256 value) public {

    }

    function burn(uint256 value) public {

    }
}
