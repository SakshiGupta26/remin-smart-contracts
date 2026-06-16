
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CalculatorSmartContract {

    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }

    function subtract(uint256 a, uint256 b) public pure returns (uint256) {
        require(a >= b, "Result would be negative");
        return a - b;
    }

    function multiply(uint256 a, uint256 b) public pure returns (uint256) {
        return a * b;
    }

    function divide(uint256 a, uint256 b) public pure returns (uint256) {
        require(b != 0, "Cannot divide by zero");
        return a / b;
    }

    function modulus(uint256 a, uint256 b) public pure returns (uint256) {
        require(b != 0, "Cannot perform modulus by zero");
        return a % b;
    }
}
