// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;

    /// @dev 每个测试前部署一份全新合约，测试之间互不影响
    function setUp() public {
        voting = new Voting();
    }

    /// @dev 单次投票后得票数为 1
    function testVoteIncrements() public {
        voting.vote("Alice");
        assertEq(voting.getVotes("Alice"), 1);
    }

    /// @dev 不同地址给同一候选人投票时票数累加
    function testMultipleVotersAccumulate() public {
        voting.vote("Alice");
        vm.prank(address(0xBEEF));
        voting.vote("Alice");
        assertEq(voting.getVotes("Alice"), 2);
    }

    /// @dev 从未被投票的候选人返回 0
    function testUnknownCandidateReturnsZero() public view {
        assertEq(voting.getVotes("Nobody"), 0);
    }

    /// @dev reset 后旧票数全部归零，且新一轮可以正常投票
    function testResetClearsVotesAndCandidates() public {
        voting.vote("Alice");
        voting.vote("Bob");
        voting.resetVotes();
        assertEq(voting.getVotes("Alice"), 0);
        assertEq(voting.getVotes("Bob"), 0);
        voting.vote("Carol");
        assertEq(voting.getVotes("Carol"), 1);
    }

    /// @dev 非 owner 调用 resetVotes 必须回滚
    function testResetOnlyOwnerReverts() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("not owner");
        voting.resetVotes();
    }

    /// @dev fuzz：连续投 n 票后得票数精确等于 n
    function testFuzzVoteCount(uint8 n) public {
        n = uint8(bound(n, 1, 50));
        for (uint256 i; i < n; ++i) {
            voting.vote("Alice");
        }
        assertEq(voting.getVotes("Alice"), n);
    }

    /// @dev 回归测试：200 个候选人时 reset 仍应是 O(1)，gas 不超过 10 万（旧实现约 220 万）
    function testResetGasBoundedWithManyCandidates() public {
        for (uint256 i; i < 200; ++i) {
            voting.vote(string.concat("c", vm.toString(i)));
        }

        uint256 gasBefore = gasleft();
        voting.resetVotes();
        uint256 gasUsed = gasBefore - gasleft();

        assertLt(gasUsed, 100_000);
        assertEq(voting.getVotes("c0"), 0);
        assertEq(voting.getVotes("c199"), 0);
    }
}
