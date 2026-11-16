// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MergeSortedArray {
    function mergeSorted(uint256[] memory a, uint256[] memory b) public pure returns (uint256[] memory) {
        uint256[] memory result = new uint256[](a.length + b.length);
        uint256 i;
        uint256 j;
        uint256 k;

        while (i < a.length && j < b.length) {
            if (a[i] <= b[j]) {
                result[k++] = a[i++];
            } else {
                result[k++] = b[j++];
            }
        }
        while (i < a.length) {
            result[k++] = a[i++];
        }
        while (j < b.length) {
            result[k++] = b[j++];
        }
        return result;
    }
}
