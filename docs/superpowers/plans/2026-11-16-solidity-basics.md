# 作业一：Solidity 基础练习 — 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 用 Foundry 实现作业一的 6 道 Solidity 练习，每题配完整测试并推送为独立 GitHub 仓库。

**Architecture:** 每个练习一个独立合约文件和一个独立测试文件，互不依赖；共享只有 forge-std。仓库即一个标准 Foundry 项目。

**Tech Stack:** Solidity 0.8.24、Foundry 1.9.0、forge-std。

**Spec:** `docs/superpowers/specs/2026-11-16-solidity-basics-design.md`

## Global Constraints

- `pragma solidity ^0.8.24;`，依赖只有 forge-std。
- 每个任务结束时 `forge test` 通过，提交信息用 conventional commits，结尾附：
  `Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>`
- 字符串反转只保证 ASCII，README 必须注明。
- 整数转罗马范围 1–3999，越界 revert；罗马转整数遇空串/非法字符 revert。
- 二分查找未命中返回 `-1`；重复元素返回任一合法下标。
- 仓库路径：`/Users/zulg/solidity-homework01`；远程 `git@github.com:zzhullong/solidity-homework01.git`。

## Review Focus

- 空输入：空串反转、空数组二分/合并必须可用，不能越界或 revert。
- 罗马边界：`0` 与 `4000` 必须 revert，`1`/`3999` 必须正确。
- 非法罗马字符：`""`、`"ABC"`、`"IIIIII"`（算法允许累加，但字符必须合法）行为明确。
- 二分重复值：返回下标必须指向目标值且不越界。
- Voting reset：清空后可重新投票，且非 owner 无法 reset。

---

### Task 1: 初始化 Foundry 仓库

**Files:**
- Create: `foundry.toml`, `remappings.txt`, `.gitignore`, `README.md`, `lib/forge-std`
- Create dirs: `src/`, `test/`, `script/`

**Interfaces:**
- Produces: 可运行 `forge build` 的空项目，后续任务直接往里加合约。

- [ ] **Step 1: 建目录并初始化 git**

```bash
mkdir -p /Users/zulg/solidity-homework01/{src,test,script,lib}
cd /Users/zulg/solidity-homework01
git init -b main
```

- [ ] **Step 2: 写 `foundry.toml` 与 `remappings.txt`**

`foundry.toml`：
```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc = "0.8.24"
optimizer = true
optimizer_runs = 200
```
`remappings.txt`：
```
forge-std/=lib/forge-std/src/
```

- [ ] **Step 3: 安装 forge-std**

```bash
forge install foundry-rs/forge-std
```
若 HTTPS 安装因网络失败，改用：
```bash
git clone --depth 1 git@github.com:foundry-rs/forge-std.git lib/forge-std
git submodule add git@github.com:foundry-rs/forge-std.git lib/forge-std || true
git config -f .gitmodules submodule.lib/forge-std.url https://github.com/foundry-rs/forge-std.git
```

- [ ] **Step 4: 写 `.gitignore` 与 README 骨架**

`.gitignore`：
```
out/
cache/
broadcast/
.env
```
`README.md`：标题、作业来源链接、题目列表占位、运行方式 `forge test`。

- [ ] **Step 5: 验证脚手架**

Run: `forge build`
Expected: 编译成功（无合约时输出 `Nothing to compile` 或 `Compiling...` 后成功）。

- [ ] **Step 6: 首次提交**

```bash
git add -A
git commit -m "chore: scaffold foundry project"
```

---

### Task 2: Voting 合约

**Files:**
- Create: `src/Voting.sol`
- Test: `test/Voting.t.sol`

**Interfaces:**
- Produces:
  ```solidity
  contract Voting {
      constructor();
      function vote(string calldata candidate) external;
      function getVotes(string calldata candidate) external view returns (uint256);
      function resetVotes() external;
  }
  ```

- [ ] **Step 1: 写失败测试**

```solidity
// test/Voting.t.sol
contract VotingTest is Test {
    Voting voting;
    address owner = address(this);

    function setUp() public { voting = new Voting(); }

    function testVoteIncrements() public {
        voting.vote("Alice");
        assertEq(voting.getVotes("Alice"), 1);
    }
    function testMultipleVotersAccumulate() public {
        voting.vote("Alice");
        vm.prank(address(0xBEEF));
        voting.vote("Alice");
        assertEq(voting.getVotes("Alice"), 2);
    }
    function testUnknownCandidateReturnsZero() public view {
        assertEq(voting.getVotes("Nobody"), 0);
    }
    function testResetClearsVotesAndCandidates() public {
        voting.vote("Alice");
        voting.vote("Bob");
        voting.resetVotes();
        assertEq(voting.getVotes("Alice"), 0);
        assertEq(voting.getVotes("Bob"), 0);
        voting.vote("Carol");
        assertEq(voting.getVotes("Carol"), 1);
    }
    function testResetOnlyOwnerReverts() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert();
        voting.resetVotes();
    }
    function testFuzzVoteCount(uint8 n) public {
        n = uint8(bound(n, 1, 50));
        for (uint256 i; i < n; ++i) voting.vote("Alice");
        assertEq(voting.getVotes("Alice"), n);
    }
}
```

- [ ] **Step 2: 运行并确认失败**

Run: `forge test --match-contract VotingTest`
Expected: 编译失败（Voting 未定义）。

- [ ] **Step 3: 实现 `src/Voting.sol`**

要点：`address public immutable owner`；`mapping(string => uint256) private votes`；`string[] private candidates`；`vote` 在 `votes[candidate] == 0` 时把 candidate 推入数组；`resetVotes` 仅 owner，遍历 `candidates` 清零后 `delete candidates`。

- [ ] **Step 4: 运行测试通过**

Run: `forge test --match-contract VotingTest -vvv`
Expected: 6 个测试 PASS。

- [ ] **Step 5: 提交**

```bash
git add src/Voting.sol test/Voting.t.sol
git commit -m "feat: add voting contract with tests"
```

---

### Task 3: ReverseString 合约

**Files:**
- Create: `src/ReverseString.sol`
- Test: `test/ReverseString.t.sol`

**Interfaces:**
- Produces:
  ```solidity
  contract ReverseString {
      function reverse(string memory s) public pure returns (string memory);
  }
  ```

- [ ] **Step 1: 写失败测试**

```solidity
function testReverseAbcde() public view {
    assertEq(reverse.reverse("abcde"), "edcba");
}
function testReverseEmpty() public view {
    assertEq(reverse.reverse(""), "");
}
function testReverseSingleChar() public view {
    assertEq(reverse.reverse("a"), "a");
}
function testReversePalindrome() public view {
    assertEq(reverse.reverse("level"), "level");
}
function testFuzzReverseTwiceAscii(bytes memory raw) public view {
    bytes memory ascii = new bytes(raw.length);
    for (uint256 i; i < raw.length; ++i) ascii[i] = bytes1(uint8(raw[i]) % 128);
    string memory s = string(ascii);
    assertEq(reverse.reverse(reverse.reverse(s)), s);
}
```

- [ ] **Step 2: 运行并确认失败**

Run: `forge test --match-contract ReverseStringTest`
Expected: 编译失败（ReverseString 未定义）。

- [ ] **Step 3: 实现**

要点：`bytes memory b = bytes(s)`，首尾交换直到 `i >= j`，`return string(b)`。

- [ ] **Step 4: 运行测试通过**

Run: `forge test --match-contract ReverseStringTest -vvv`
Expected: 5 个测试 PASS。

- [ ] **Step 5: 提交**

```bash
git add src/ReverseString.sol test/ReverseString.t.sol
git commit -m "feat: add ascii string reversal with tests"
```

---

### Task 4: 罗马数字双向转换

**Files:**
- Create: `src/IntegerToRoman.sol`, `src/RomanToInteger.sol`
- Test: `test/Roman.t.sol`

**Interfaces:**
- Produces:
  ```solidity
  contract IntegerToRoman { function intToRoman(uint256 num) public pure returns (string memory); }
  contract RomanToInteger { function romanToInt(string memory s) public pure returns (uint256); }
  ```

- [ ] **Step 1: 写失败测试**

整数转罗马样例（LeetCode）：`3→"III"`、`4→"IV"`、`9→"IX"`、`58→"LVIII"`、`1994→"MCMXCIV"`、`1→"I"`、`3999→"MMMCMXCIX"`。
失败路径：`intToRoman(0)` 与 `intToRoman(4000)` 用 `vm.expectRevert()`。

罗马转整数样例：`"III"→3`、`"IV"→4`、`"IX"→9`、`"LVIII"→58`、`"MCMXCIV"→1994`；`""`、`"ABC"`、`"IIII"`（合法字符但非规范写法）需要明确行为——本实现只校验字符合法，`"IIII"→4`，因此测试断言为 `4`，非法字符与空串 `vm.expectRevert()`。

fuzz：`testFuzzRomanRoundTrip(uint256 n)`，`n = bound(n, 1, 3999)`，断言 `romanToInt(intToRoman(n)) == n`。

- [ ] **Step 2: 运行并确认失败**

Run: `forge test --match-contract RomanTest`
Expected: 编译失败。

- [ ] **Step 3: 实现**

`IntegerToRoman`：贪心表 `[1000,900,500,400,100,90,50,40,10,9,5,4,1]` 与对应符号，循环拼接；`require(num >= 1 && num <= 3999)`。
`RomanToInteger`：从右向左扫描，维护 `maxSeen`；字符映射不合法 `revert()`；`value < maxSeen` 则累减，否则累加并更新 `maxSeen`。

- [ ] **Step 4: 运行测试通过**

Run: `forge test --match-contract RomanTest -vvv`
Expected: 全部 PASS。

- [ ] **Step 5: 提交**

```bash
git add src/IntegerToRoman.sol src/RomanToInteger.sol test/Roman.t.sol
git commit -m "feat: add roman numeral conversions with tests"
```

---

### Task 5: MergeSortedArray 合约

**Files:**
- Create: `src/MergeSortedArray.sol`
- Test: `test/MergeSortedArray.t.sol`

**Interfaces:**
- Produces:
  ```solidity
  contract MergeSortedArray {
      function mergeSorted(uint256[] memory a, uint256[] memory b)
          public pure returns (uint256[] memory);
  }
  ```

- [ ] **Step 1: 写失败测试**

```solidity
function testMergeBasic() public view {
    uint256[] memory a = arr(1, 3, 5);
    uint256[] memory b = arr(2, 4, 6);
    assertEq(merge.mergeSorted(a, b), arr(1, 2, 3, 4, 5, 6));
}
function testMergeOneEmpty() public view {
    assertEq(merge.mergeSorted(new uint256[](0), arr(1, 2)), arr(1, 2));
}
function testMergeBothEmpty() public view {
    assertEq(merge.mergeSorted(new uint256[](0), new uint256[](0)).length, 0);
}
function testMergeDuplicates() public view {
    assertEq(merge.mergeSorted(arr(1, 1, 3), arr(1, 2)), arr(1, 1, 1, 2, 3));
}
function testFuzzMergeSorted(bytes calldata seedA, bytes calldata seedB) public view {
    // 由 seed 生成两个升序数组，断言输出长度正确且非降序
}
```
`arr(...)` 为测试内私有 helper。

- [ ] **Step 2: 运行并确认失败**

Run: `forge test --match-contract MergeSortedArrayTest`
Expected: 编译失败。

- [ ] **Step 3: 实现**

双指针 `i`、`j`，每次取较小者写入 `result[k]`，任一数组耗尽后复制剩余部分。

- [ ] **Step 4: 运行测试通过**

Run: `forge test --match-contract MergeSortedArrayTest -vvv`
Expected: 全部 PASS。

- [ ] **Step 5: 提交**

```bash
git add src/MergeSortedArray.sol test/MergeSortedArray.t.sol
git commit -m "feat: add merge sorted arrays with tests"
```

---

### Task 6: BinarySearch 合约

**Files:**
- Create: `src/BinarySearch.sol`
- Test: `test/BinarySearch.t.sol`

**Interfaces:**
- Produces:
  ```solidity
  contract BinarySearch {
      function binarySearch(uint256[] memory arr, uint256 target)
          public pure returns (int256);
  }
  ```

- [ ] **Step 1: 写失败测试**

```solidity
function testFindFirstMiddleLast() public view {
    uint256[] memory a = arr(1, 3, 5, 7, 9);
    assertEq(search.binarySearch(a, 1), int256(0));
    assertEq(search.binarySearch(a, 5), int256(2));
    assertEq(search.binarySearch(a, 9), int256(4));
}
function testNotFoundReturnsMinusOne() public view {
    assertEq(search.binarySearch(arr(1, 3, 5), 4), int256(-1));
}
function testEmptyReturnsMinusOne() public view {
    assertEq(search.binarySearch(new uint256[](0), 1), int256(-1));
}
function testDuplicateReturnsValidIndex() public view {
    uint256[] memory a = arr(1, 2, 2, 2, 3);
    int256 idx = search.binarySearch(a, 2);
    assertTrue(idx >= 0);
    assertEq(a[uint256(idx)], 2);
}
function testFuzzMatchesLinearSearch(bytes calldata seed, uint256 target) public view {
    // 生成升序数组，断言存在性与线性扫描一致；若返回下标，则必须指向 target
}
```

- [ ] **Step 2: 运行并确认失败**

Run: `forge test --match-contract BinarySearchTest`
Expected: 编译失败。

- [ ] **Step 3: 实现**

标准 `lo/hi` 循环，`mid = lo + (hi - lo) / 2`，避免加法溢出；未找到 `return -1`。

- [ ] **Step 4: 运行测试通过**

Run: `forge test --match-contract BinarySearchTest -vvv`
Expected: 全部 PASS。

- [ ] **Step 5: 提交**

```bash
git add src/BinarySearch.sol test/BinarySearch.t.sol
git commit -m "feat: add binary search with tests"
```

---

### Task 7: README、格式与全量验证

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 补全 README**

内容：作业来源链接、6 道题列表与对应合约路径、`forge test` / `forge test -vvv` 运行说明、ASCII 反转限制说明、罗马范围说明。

- [ ] **Step 2: 全量测试**

Run: `forge test -vvv`
Expected: 全部 PASS，0 failed。

- [ ] **Step 3: 格式检查**

Run: `forge fmt --check`
Expected: 无输出、退出码 0。若有差异，运行 `forge fmt` 后重新测试。

- [ ] **Step 4: 提交**

```bash
git add README.md
git commit -m "docs: describe exercises and how to run tests"
```

---

### Task 8: 创建并推送远程仓库

**前置条件：** 用户已在 GitHub 创建空仓库 `zzhullong/solidity-homework01`，或提供了可创建仓库的凭据。

- [ ] **Step 1: 关联远程**

```bash
cd /Users/zulg/solidity-homework01
git remote add origin git@github.com:zzhullong/solidity-homework01.git
```

- [ ] **Step 2: 推送并验证**

```bash
git push -u origin main
git ls-remote --heads origin
```
Expected: 输出包含 `refs/heads/main`，提交 SHA 与本地 `git rev-parse HEAD` 一致。
