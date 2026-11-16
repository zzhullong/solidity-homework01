// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ReverseString} from "../src/ReverseString.sol";

contract ReverseStringTest is Test {
    ReverseString reverse;

    function setUp() public {
        reverse = new ReverseString();
    }

    function testReverseAbcde() public view {
        assertEq(reverse.reverse("abcde"), "edcba");
    }

    function testReverseEmpty() public view {
        assertEq(reverse.reverse(""), "");
    }

    function testReverseSingleChar() public view {
        assertEq(reverse.reverse("a"), "a");
    }

    function testReversePalindrome() public view {
        assertEq(reverse.reverse("level"), "level");
    }

    function testFuzzReverseTwiceAscii(bytes memory raw) public view {
        bytes memory ascii = new bytes(raw.length);
        for (uint256 i; i < raw.length; ++i) {
            ascii[i] = bytes1(uint8(raw[i]) % 128);
        }
        string memory s = string(ascii);
        assertEq(reverse.reverse(reverse.reverse(s)), s);
    }
}
