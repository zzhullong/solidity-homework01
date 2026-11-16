// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {
    Voting voting;

    function setUp() public {
        voting = new Voting();
    }

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
        for (uint256 i; i < n; ++i) {
            voting.vote("Alice");
        }
        assertEq(voting.getVotes("Alice"), n);
    }
}
