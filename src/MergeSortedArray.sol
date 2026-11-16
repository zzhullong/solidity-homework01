// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title 合并两个有序数组
/// @notice 输入两个升序数组，返回合并后的升序数组；允许重复元素和空数组。
contract MergeSortedArray {
    /// @notice 双指针合并两个升序数组
    /// @param a 第一个升序数组
    /// @param b 第二个升序数组
    /// @return 合并后的升序数组，长度为两个输入长度之和
    function mergeSorted(uint256[] memory a, uint256[] memory b) public pure returns (uint256[] memory) {
        uint256[] memory result = new uint256[](a.length + b.length);
        uint256 i;
        uint256 j;
        uint256 k;

        // 两个指针各指向一个数组，每次取较小的元素写入结果
        while (i < a.length && j < b.length) {
            if (a[i] <= b[j]) {
                result[k++] = a[i++];
            } else {
                result[k++] = b[j++];
            }
        }
        // 任一数组剩余元素已经有序，直接追加
        while (i < a.length) {
            result[k++] = a[i++];
        }
        while (j < b.length) {
            result[k++] = b[j++];
        }
        return result;
    }
}
