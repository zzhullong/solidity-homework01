// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BinarySearch {
    function binarySearch(uint256[] memory arr, uint256 target) public pure returns (int256) {
        uint256 lo;
        uint256 hi = arr.length;

        while (lo < hi) {
            uint256 mid = lo + (hi - lo) / 2;
            if (arr[mid] == target) {
                return int256(mid);
            }
            if (arr[mid] < target) {
                lo = mid + 1;
            } else {
                hi = mid;
            }
        }
        return -1;
    }
}
