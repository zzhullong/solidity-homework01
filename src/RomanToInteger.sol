// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract RomanToInteger {
    function romanToInt(string memory s) public pure returns (uint256) {
        bytes memory b = bytes(s);
        require(b.length > 0, "empty string");

        uint256 total;
        uint256 maxSeen;
        for (uint256 i = b.length; i > 0; --i) {
            uint256 value = _value(b[i - 1]);
            if (value < maxSeen) {
                total -= value;
            } else {
                total += value;
                maxSeen = value;
            }
        }
        return total;
    }

    function _value(bytes1 c) private pure returns (uint256) {
        if (c == bytes1("I")) return 1;
        if (c == bytes1("V")) return 5;
        if (c == bytes1("X")) return 10;
        if (c == bytes1("L")) return 50;
        if (c == bytes1("C")) return 100;
        if (c == bytes1("D")) return 500;
        if (c == bytes1("M")) return 1000;
        revert("invalid roman character");
    }
}
