// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MergeSortedArray} from "../src/MergeSortedArray.sol";

contract MergeSortedArrayTest is Test {
    MergeSortedArray merge;

    function setUp() public {
        merge = new MergeSortedArray();
    }

    function testMergeBasic() public view {
        assertEq(merge.mergeSorted(arr3(1, 3, 5), arr3(2, 4, 6)), arr6(1, 2, 3, 4, 5, 6));
    }

    function testMergeOneEmpty() public view {
        assertEq(merge.mergeSorted(new uint256[](0), arr2(1, 2)), arr2(1, 2));
        assertEq(merge.mergeSorted(arr2(1, 2), new uint256[](0)), arr2(1, 2));
    }

    function testMergeBothEmpty() public view {
        uint256[] memory result = merge.mergeSorted(new uint256[](0), new uint256[](0));
        assertEq(result.length, 0);
    }

    function testMergeDuplicates() public view {
        assertEq(merge.mergeSorted(arr3(1, 1, 3), arr2(1, 2)), arr5(1, 1, 1, 2, 3));
    }

    function testFuzzMergeSortedProperty(bytes calldata seedA, bytes calldata seedB) public view {
        uint256[] memory a = _sortedFromSeed(seedA);
        uint256[] memory b = _sortedFromSeed(seedB);
        uint256[] memory result = merge.mergeSorted(a, b);

        assertEq(result.length, a.length + b.length);
        for (uint256 i = 1; i < result.length; ++i) {
            assertLe(result[i - 1], result[i]);
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

    function arr2(uint256 a, uint256 b) private pure returns (uint256[] memory r) {
        r = new uint256[](2);
        (r[0], r[1]) = (a, b);
    }

    function arr3(uint256 a, uint256 b, uint256 c) private pure returns (uint256[] memory r) {
        r = new uint256[](3);
        (r[0], r[1], r[2]) = (a, b, c);
    }

    function arr5(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e)
        private
        pure
        returns (uint256[] memory r)
    {
        r = new uint256[](5);
        (r[0], r[1], r[2], r[3], r[4]) = (a, b, c, d, e);
    }

    function arr6(uint256 a, uint256 b, uint256 c, uint256 d, uint256 e, uint256 f)
        private
        pure
        returns (uint256[] memory r)
    {
        r = new uint256[](6);
        (r[0], r[1], r[2], r[3], r[4], r[5]) = (a, b, c, d, e, f);
    }
}
