// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BinarySearch} from "../src/BinarySearch.sol";

contract BinarySearchTest is Test {
    BinarySearch search;

    function setUp() public {
        search = new BinarySearch();
    }

    function testFindFirstMiddleLast() public view {
        uint256[] memory a = arr5(1, 3, 5, 7, 9);
        assertEq(search.binarySearch(a, 1), int256(0));
        assertEq(search.binarySearch(a, 5), int256(2));
        assertEq(search.binarySearch(a, 9), int256(4));
    }

    function testNotFoundReturnsMinusOne() public view {
        assertEq(search.binarySearch(arr3(1, 3, 5), 4), int256(-1));
    }

    function testEmptyReturnsMinusOne() public view {
        assertEq(search.binarySearch(new uint256[](0), 1), int256(-1));
    }

    function testDuplicateReturnsValidIndex() public view {
        uint256[] memory a = arr5(1, 2, 2, 2, 3);
        int256 idx = search.binarySearch(a, 2);
        assertTrue(idx >= 0);
        assertEq(a[uint256(idx)], 2);
    }

    function testFuzzMatchesLinearSearch(bytes calldata seed, uint256 target) public view {
        uint256[] memory a = _sortedFromSeed(seed);
        target = target % 40;

        bool expected;
        for (uint256 i; i < a.length; ++i) {
            if (a[i] == target) {
                expected = true;
                break;
            }
        }

        int256 idx = search.binarySearch(a, target);
        if (!expected) {
            assertEq(idx, int256(-1));
        } else {
            assertTrue(idx >= 0);
            assertLt(uint256(idx), a.length);
            assertEq(a[uint256(idx)], target);
        }
    }

    function _sortedFromSeed(bytes calldata seed) private pure returns (uint256[] memory sorted) {
        uint256 n = seed.length % 9;
        sorted = new uint256[](n);
        for (uint256 i; i < n; ++i) {
            sorted[i] = uint256(uint8(seed[i])) % 32;
        }
        for (uint256 i = 1; i < n; ++i) {
            uint256 key = sorted[i];
            uint256 j = i;
            while (j > 0 && sorted[j - 1] > key) {
                sorted[j] = sorted[j - 1];
                --j;
            }
            sorted[j] = key;
        }
    }

    function arr3(uint256 a, uint256 b, uint256 c) private pure returns (uint256[] memory r) {
        r = new uint256[](3);
        (r[0], r[1], r[2]) = (a, b, c);
    }

    function arr5(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e) private pure returns (uint256[] memory r) {
        r = new uint256[](5);
        (r[0], r[1], r[2], r[3], r[4]) = (a, b, c, d, e);
    }
}
