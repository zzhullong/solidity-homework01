// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {RomanToInteger} from "../src/RomanToInteger.sol";

contract RomanToIntegerTest is Test {
    RomanToInteger toInt;

    function setUp() public {
        toInt = new RomanToInteger();
    }

    function testRomanToIntExamples() public view {
        assertEq(toInt.romanToInt("III"), 3);
        assertEq(toInt.romanToInt("IV"), 4);
        assertEq(toInt.romanToInt("IX"), 9);
        assertEq(toInt.romanToInt("LVIII"), 58);
        assertEq(toInt.romanToInt("MCMXCIV"), 1994);
    }

    function testRomanToIntEmptyReverts() public {
        vm.expectRevert("empty string");
        toInt.romanToInt("");
    }

    function testRomanToIntInvalidCharReverts() public {
        vm.expectRevert("invalid roman character");
        toInt.romanToInt("ABC");
    }

    function testRomanToIntNonCanonicalAdds() public view {
        assertEq(toInt.romanToInt("IIII"), 4);
    }
}
