// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {RomanToInteger} from "../src/RomanToInteger.sol";

contract RomanToIntegerTest is Test {
    RomanToInteger toInt;

    function setUp() public {
        toInt = new RomanToInteger();
    }

    /// @dev LeetCode 样例，包含 IV/IX/XC 等减法组合
    function testRomanToIntExamples() public view {
        assertEq(toInt.romanToInt("III"), 3);
        assertEq(toInt.romanToInt("IV"), 4);
        assertEq(toInt.romanToInt("IX"), 9);
        assertEq(toInt.romanToInt("LVIII"), 58);
        assertEq(toInt.romanToInt("MCMXCIV"), 1994);
    }

    /// @dev 空字符串必须回滚
    function testRomanToIntEmptyReverts() public {
        vm.expectRevert("empty string");
        toInt.romanToInt("");
    }

    /// @dev 非法字符必须回滚
    function testRomanToIntInvalidCharReverts() public {
        vm.expectRevert("invalid roman character");
        toInt.romanToInt("ABC");
    }

    /// @dev 字符合法但非规范的写法按累加处理：IIII -> 4
    function testRomanToIntNonCanonicalAdds() public view {
        assertEq(toInt.romanToInt("IIII"), 4);
    }
}
