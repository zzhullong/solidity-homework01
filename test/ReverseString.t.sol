// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {ReverseString} from "../src/ReverseString.sol";

contract ReverseStringTest is Test {
    ReverseString reverse;

    function setUp() public {
        reverse = new ReverseString();
    }

    /// @dev 作业样例：abcde -> edcba
    function testReverseAbcde() public view {
        assertEq(reverse.reverse("abcde"), "edcba");
    }

    /// @dev 空字符串保持为空
    function testReverseEmpty() public view {
        assertEq(reverse.reverse(""), "");
    }

    /// @dev 单字符保持不变
    function testReverseSingleChar() public view {
        assertEq(reverse.reverse("a"), "a");
    }

    /// @dev 回文字符串反转后与原串相同
    function testReversePalindrome() public view {
        assertEq(reverse.reverse("level"), "level");
    }

    /// @dev fuzz：把输入限制为 ASCII 后，反转两次应还原原串
    function testFuzzReverseTwiceAscii(bytes memory raw) public view {
        bytes memory ascii = new bytes(raw.length);
        for (uint256 i; i < raw.length; ++i) {
            ascii[i] = bytes1(uint8(raw[i]) % 128);
        }
        string memory s = string(ascii);
        assertEq(reverse.reverse(reverse.reverse(s)), s);
    }
}
