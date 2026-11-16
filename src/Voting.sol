// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    address public immutable owner;
    mapping(string => uint256) private votes;
    mapping(string => uint256) private voteEpoch;
    uint256 private epoch;

    constructor() {
        owner = msg.sender;
        epoch = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function vote(string calldata candidate) external {
        if (voteEpoch[candidate] != epoch) {
            voteEpoch[candidate] = epoch;
            votes[candidate] = 0;
        }
        votes[candidate] += 1;
    }

    function getVotes(string calldata candidate) external view returns (uint256) {
        return voteEpoch[candidate] == epoch ? votes[candidate] : 0;
    }

    function resetVotes() external onlyOwner {
        epoch += 1;
    }
}
