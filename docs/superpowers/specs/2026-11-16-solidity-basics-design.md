# 作业一：Solidity 基础练习 — 设计文档

日期：2026-11-16
作业：MetaNodeAcademy LearningRoadmap `contract/homework01.md`
实现工具链：Foundry（经用户确认）

## 1. 背景与目标

作业一包含 6 道题：Voting 合约、字符串反转、整数转罗马数字、罗马数字转整数、合并两个有序数组、二分查找。用 Solidity 实现并为每道题编写完整测试。

目标：
- 6 道题全部实现，函数签名与行为符合作业描述。
- 每道题独立的测试文件，覆盖正常路径、边界与失败路径。
- `forge test` 全绿，`forge fmt --check` 干净。
- README 说明题目、实现与运行方式。

非目标：
- 不做前端、部署到测试网（作业一未要求）。
- 不做 gas 极致优化。
- 不引入 OpenZeppelin 等外部依赖，只用 forge-std。

失败标准（anti-goals）：
- 任何一道题无测试或测试只覆盖 happy path。
- 二分查找返回非法索引（越界或指向非目标值）。
- Roman 转换在边界或非法输入上静默给出错误结果。
- 仓库无法用一条 `forge test` 复现结果。

## 2. 约束

- Solidity `^0.8.24`，Foundry 1.9.0，依赖仅 forge-std。
- 字符串反转按 bytes 操作，只保证 ASCII 输入正确；README 明确说明，不静默声称支持 Unicode。
- 整数转罗马要求 1–3999，超出范围 revert。
- 罗马转整数遇到空串或非 `I V X L C D M` 字符 revert。
- 候选人用字符串标识（作业用 `mapping` 记录得票，未限定 key 类型）。

## 3. 接口

### Voting
```solidity
contract Voting {
    constructor();
    function vote(string calldata candidate) external;
    function getVotes(string calldata candidate) external view returns (uint256);
    function resetVotes() external; // onlyOwner
}
```
- `mapping(string => uint256)` 存票数，`string[]` 维护候选人列表以便 reset 清空。
- `resetVotes` 仅部署者（owner）可调用；清空票数并清空候选人列表。

### ReverseString
```solidity
contract ReverseString {
    function reverse(string memory s) public pure returns (string memory);
}
```

### Roman
```solidity
contract IntegerToRoman {
    function intToRoman(uint256 num) public pure returns (string memory);
}
contract RomanToInteger {
    function romanToInt(string memory s) public pure returns (uint256);
}
```
- `intToRoman` 用贪心查表（1000/900/500/400/…/4/1），`require(1 <= num && num <= 3999)`。
- `romanToInt` 从右向左扫描：当前值小于已见最大值则减，否则加；非法字符 revert。

### MergeSortedArray
```solidity
contract MergeSortedArray {
    function mergeSorted(uint256[] memory a, uint256[] memory b)
        public pure returns (uint256[] memory);
}
```
- 双指针合并，元素可重复，空数组合法。

### BinarySearch
```solidity
contract BinarySearch {
    function binarySearch(uint256[] memory arr, uint256 target)
        public pure returns (int256);
}
```
- 返回任一命中的下标；未找到返回 `-1`；空数组返回 `-1`。

## 4. 测试策略

- 每题一个 `test/*.t.sol`，使用 forge-std `Test`。
- 正常路径 + 边界 + 失败路径（`vm.expectRevert`）。
- 关键不变量用 fuzz 测试：
  - 反转两次等于原串（ASCII）。
  - 1–3999 内 `romanToInt(intToRoman(n)) == n`。
  - 合并结果长度正确且有序。
  - 二分结果与线性查找的“是否存在”一致，且命中索引指向目标值。
  - 多次投票后票数等于调用次数。
