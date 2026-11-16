# Solidity 基础练习（作业一）

MetaNodeAcademy LearningRoadmap [`contract/homework01.md`](https://github.com/MetaNodeAcademy/LearningRoadmap/blob/main/contract/homework01.md) 的实现，使用 Foundry 开发与测试。

## 练习列表

| # | 练习 | 合约 | 测试 |
|---|---|---|---|
| 1 | Voting 投票合约 | `src/Voting.sol` | `test/Voting.t.sol` |
| 2 | 字符串反转 | `src/ReverseString.sol` | `test/ReverseString.t.sol` |
| 3 | 整数转罗马数字 | `src/IntegerToRoman.sol` | `test/Roman.t.sol` |
| 4 | 罗马数字转整数 | `src/RomanToInteger.sol` | `test/Roman.t.sol` |
| 5 | 合并两个有序数组 | `src/MergeSortedArray.sol` | `test/MergeSortedArray.t.sol` |
| 6 | 二分查找 | `src/BinarySearch.sol` | `test/BinarySearch.t.sol` |

## 实现说明

- **Voting**：`mapping(string => uint256)` 记录得票，同时维护候选人数组以便重置。`resetVotes` 仅部署者（owner）可调用，重置后候选人列表一并清空，可重新开始投票。
- **ReverseString**：按字节首尾交换。只保证 ASCII 输入正确；传入多字节 UTF-8 字符时按字节反转，结果不保证是合法字符串。
- **IntegerToRoman**：贪心查表，支持 1–3999，超出范围 revert。
- **RomanToInteger**：从右向左扫描，遇到小于当前最大值的字符做减法。空串或非法字符 revert；`IIII` 这类非规范但字符合法的输入按累加返回 4。
- **MergeSortedArray**：双指针合并，允许重复元素与空数组。
- **BinarySearch**：返回任一命中的下标；未找到或空数组返回 `-1`。

## 运行测试

```bash
forge test -vvv
```

只跑某一道题：

```bash
forge test --match-contract VotingTest -vvv
```

## 项目结构

```
src/    合约实现
test/   Foundry 测试
lib/    forge-std（git submodule）
```

## 工具链

- Solidity `^0.8.24`
- Foundry（forge / cast / anvil）
- 测试依赖 [forge-std](https://github.com/foundry-rs/forge-std)

克隆后如未拉取子模块，先执行：

```bash
git submodule update --init --recursive
```
