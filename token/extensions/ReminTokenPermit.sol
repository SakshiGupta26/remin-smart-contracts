```solidity id="7g8wqk"
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ReminTokenPermit {

    bytes32 private constant PERMIT_TYPEHASH =
        keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );

    mapping(address => uint256) public nonces;

    bytes32 public DOMAIN_SEPARATOR;

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor() {

    }

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {

    }

    function getNonce(address owner) public returns (uint256) {

    }

    function domainSeparator() public returns (bytes32) {

    }

    function recoverSigner(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public returns (address) {

    }
}
```
