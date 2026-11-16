// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    address public immutable owner;
    mapping(string => uint256) private votes;
    string[] private candidates;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function vote(string calldata candidate) external {
        if (votes[candidate] == 0) {
            candidates.push(candidate);
        }
        votes[candidate] += 1;
    }

    function getVotes(string calldata candidate) external view returns (uint256) {
        return votes[candidate];
    }

    function resetVotes() external onlyOwner {
        for (uint256 i; i < candidates.length; ++i) {
            delete votes[candidates[i]];
        }
        delete candidates;
    }
}
