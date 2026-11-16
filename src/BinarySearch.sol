// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title 二分查找
/// @notice 在升序数组中查找目标值，返回任一命中的下标；未找到返回 -1。
contract BinarySearch {
    /// @notice 二分查找目标值
    /// @param arr 升序数组
    /// @param target 要查找的目标值
    /// @return 命中时返回任一合法下标，未找到或空数组返回 -1
    /// @dev 要求输入数组已按升序排列；重复元素返回其中一个下标即可
    function binarySearch(uint256[] memory arr, uint256 target) public pure returns (int256) {
        // 使用半开区间 [lo, hi)，循环结束时表示未找到
        uint256 lo;
        uint256 hi = arr.length;

        while (lo < hi) {
            // 用 lo + (hi - lo) / 2 计算中点，避免 lo + hi 溢出
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
