// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Voting 投票合约
/// @notice 按候选人名称累计票数；任何人都可以投票，部署者可以将所有票数清零。
contract Voting {
    /// @notice 合约部署者，唯一有权重置票数的地址
    address public immutable owner;

    /// @dev 候选人名称 => 当前轮次票数
    mapping(string => uint256) private votes;

    /// @dev 候选人名称 => 最近一次投票所在轮次，用于判断票数是否已过期
    mapping(string => uint256) private voteEpoch;

    /// @dev 当前计票轮次；resetVotes 递增该值，使旧票数全部失效
    uint256 private epoch;

    event VoteCandidate(string indexed candidate,uint256 indexed num);
    event ResetVotes(address indexed account, uint256 amount);


    
    constructor() {
        owner = msg.sender;
        // 从 1 开始，避免与未初始化 mapping 的默认值 0 混淆
        epoch = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /// @notice 给候选人投一票
    /// @param candidate 候选人名称
    function vote(string calldata candidate) external {
        // 候选人在本轮首次出现时初始化票数；上一轮的票数视为已作废
        if (voteEpoch[candidate] != epoch) {
            voteEpoch[candidate] = epoch;
            votes[candidate] = 0;
        }
        uint256 num = votes[candidate] += 1;
        
        emit VoteCandidate(candidate,num);
    }

    /// @notice 查询候选人当前轮次的得票数；未投票或已重置返回 0
    /// @param candidate 候选人名称
    function getVotes(string calldata candidate) external view returns (uint256) {
        // 只返回本轮票数，旧轮次数据直接视为 0
        return voteEpoch[candidate] == epoch ? votes[candidate] : 0;
    }

    /// @notice 重置所有候选人的票数（仅 owner）
    /// @dev 只递增 epoch，不遍历候选人列表，因此无论有多少候选人都保持 O(1)
    function resetVotes() external onlyOwner {
        epoch += 1;
        emit ResetVotes(msg.sender,epoch);
    }
}
