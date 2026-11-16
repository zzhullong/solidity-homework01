// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IntegerToRoman} from "../src/IntegerToRoman.sol";
import {RomanToInteger} from "../src/RomanToInteger.sol";

contract RomanTest is Test {
    IntegerToRoman toRoman;
    RomanToInteger toInt;

    function setUp() public {
        toRoman = new IntegerToRoman();
        toInt = new RomanToInteger();
    }

    function testIntToRomanExamples() public view {
        assertEq(toRoman.intToRoman(1), "I");
        assertEq(toRoman.intToRoman(3), "III");
        assertEq(toRoman.intToRoman(4), "IV");
        assertEq(toRoman.intToRoman(9), "IX");
        assertEq(toRoman.intToRoman(58), "LVIII");
        assertEq(toRoman.intToRoman(1994), "MCMXCIV");
        assertEq(toRoman.intToRoman(3999), "MMMCMXCIX");
    }

    function testIntToRomanZeroReverts() public {
        vm.expectRevert();
        toRoman.intToRoman(0);
    }

    function testIntToRomanAbove3999Reverts() public {
        vm.expectRevert();
        toRoman.intToRoman(4000);
    }

    function testRomanToIntExamples() public view {
        assertEq(toInt.romanToInt("III"), 3);
        assertEq(toInt.romanToInt("IV"), 4);
        assertEq(toInt.romanToInt("IX"), 9);
        assertEq(toInt.romanToInt("LVIII"), 58);
        assertEq(toInt.romanToInt("MCMXCIV"), 1994);
    }

    function testRomanToIntEmptyReverts() public {
        vm.expectRevert();
        toInt.romanToInt("");
    }

    function testRomanToIntInvalidCharReverts() public {
        vm.expectRevert();
        toInt.romanToInt("ABC");
    }

    function testRomanToIntNonCanonicalAdds() public view {
        assertEq(toInt.romanToInt("IIII"), 4);
    }

    function testFuzzRomanRoundTrip(uint256 n) public view {
        n = bound(n, 1, 3999);
        assertEq(toInt.romanToInt(toRoman.intToRoman(n)), n);
    }
}
