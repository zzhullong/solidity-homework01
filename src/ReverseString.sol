// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ReverseString {
    function reverse(string memory s) public pure returns (string memory) {
        bytes memory b = bytes(s);
        for (uint256 i; i < b.length / 2; ++i) {
            uint256 j = b.length - 1 - i;
            bytes1 tmp = b[i];
            b[i] = b[j];
            b[j] = tmp;
        }
        return string(b);
    }
}
