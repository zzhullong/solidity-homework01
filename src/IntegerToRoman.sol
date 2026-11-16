// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract IntegerToRoman {
    function intToRoman(uint256 num) public pure returns (string memory) {
        require(num >= 1 && num <= 3999, "out of range");

        uint256[13] memory values = [uint256(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        string[13] memory symbols =
            ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];

        bytes memory out;
        for (uint256 i; i < values.length; ++i) {
            while (num >= values[i]) {
                out = abi.encodePacked(out, symbols[i]);
                num -= values[i];
            }
        }
        return string(out);
    }
}
