// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title 字符串反转
/// @notice 按字节反转字符串，输入 "abcde" 返回 "edcba"。
/// @dev 只保证 ASCII 输入正确；多字节 UTF-8 字符会被按字节拆开，结果不保证仍是合法字符串。
contract ReverseString {
    /// @notice 反转字符串
    /// @param s 待反转的字符串
    /// @return 反转后的字符串
    function reverse(string memory s) public pure returns (string memory) {
        bytes memory b = bytes(s);
        // 首尾对称交换，只需遍历前一半
        for (uint256 i; i < b.length / 2; ++i) {
            uint256 j = b.length - 1 - i;
            bytes1 tmp = b[i];
            b[i] = b[j];
            b[j] = tmp;
        }
        return string(b);
    }
}
