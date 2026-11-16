// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title 整数转罗马数字
/// @notice 支持 1–3999，例如输入 1994 返回 "MCMXCIV"。
contract IntegerToRoman {
    /// @notice 将整数转换为罗马数字
    /// @param num 取值范围 [1, 3999]
    /// @return 对应的罗马数字字符串
    function intToRoman(uint256 num) public pure returns (string memory) {
        require(num >= 1 && num <= 3999, "out of range");

        // 贪心查表：从大到小排列，包含 900/400/90/40/9/4 等减法组合
        uint256[13] memory values = [uint256(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        string[13] memory symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];

        bytes memory out;
        // 每一步尽量取当前最大的符号，直到 num 归零
        for (uint256 i; i < values.length; ++i) {
            while (num >= values[i]) {
                out = abi.encodePacked(out, symbols[i]);
                num -= values[i];
            }
        }
        return string(out);
    }
}
