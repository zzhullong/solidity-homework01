// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title 罗马数字转整数
/// @notice 支持 I/V/X/L/C/D/M，例如输入 "MCMXCIV" 返回 1994。
/// @dev 只校验字符是否合法，不强制规范写法；"IIII" 这类输入会按累加返回 4。
contract RomanToInteger {
    /// @notice 将罗马数字转换为整数；空串或非法字符会 revert
    /// @param s 罗马数字字符串
    /// @return 对应的整数值
    function romanToInt(string memory s) public pure returns (uint256) {
        bytes memory b = bytes(s);
        require(b.length > 0, "empty string");

        uint256 total;
        uint256 maxSeen;
        // 从右向左扫描：当前值小于右侧已见最大值时做减法（对应 IV/IX/XL 等组合）
        for (uint256 i = b.length; i > 0; --i) {
            uint256 value = _value(b[i - 1]);
            if (value < maxSeen) {
                require(total<=value,"value > total");
                total -= value;
            } else {
                total += value;
                maxSeen = value;
            }
        }
        return total;
    }

    /// @dev 单字符到数值的映射；不认识的字符直接 revert
    function _value(bytes1 c) private pure returns (uint256) {
        if (c == bytes1("I")) return 1;
        if (c == bytes1("V")) return 5;
        if (c == bytes1("X")) return 10;
        if (c == bytes1("L")) return 50;
        if (c == bytes1("C")) return 100;
        if (c == bytes1("D")) return 500;
        if (c == bytes1("M")) return 1000;
        revert("invalid roman character");
    }
}
