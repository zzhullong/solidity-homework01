// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IntegerToRoman} from "../src/IntegerToRoman.sol";
import {RomanToInteger} from "../src/RomanToInteger.sol";

contract IntegerToRomanTest is Test {
    IntegerToRoman toRoman;
    RomanToInteger toInt;

    function setUp() public {
        toRoman = new IntegerToRoman();
        toInt = new RomanToInteger();
    }

    /// @dev LeetCode 样例与上下边界
    function testIntToRomanExamples() public view {
        assertEq(toRoman.intToRoman(1), "I");
        assertEq(toRoman.intToRoman(3), "III");
        assertEq(toRoman.intToRoman(4), "IV");
        assertEq(toRoman.intToRoman(9), "IX");
        assertEq(toRoman.intToRoman(58), "LVIII");
        assertEq(toRoman.intToRoman(1994), "MCMXCIV");
        assertEq(toRoman.intToRoman(3999), "MMMCMXCIX");
    }

    /// @dev 下边界 0 必须回滚
    function testIntToRomanZeroReverts() public {
        vm.expectRevert("out of range");
        toRoman.intToRoman(0);
    }

    /// @dev 上边界之外 4000 必须回滚
    function testIntToRomanAbove3999Reverts() public {
        vm.expectRevert("out of range");
        toRoman.intToRoman(4000);
    }

    /// @dev fuzz：1–3999 内整数转罗马再转回整数应等于原值（跨合约往返一致性）
    function testFuzzRomanRoundTrip(uint256 n) public view {
        n = bound(n, 1, 3999);
        assertEq(toInt.romanToInt(toRoman.intToRoman(n)), n);
    }
}
