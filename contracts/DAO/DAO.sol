// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO {
    enum Side {Yes, No}
    enum Status {Undecided, Approved, Rejected}
    struct Proposal {
        address author;
        bytes32 hash;
        uint256 votesYes;
        uint256 votesNo;
        Status status;
        uint256 createdAt;
    }

    mapping(bytes32 => Proposal) public proposals;
    mapping(address => mapping(bytes32 => bool)) public votes;
    mapping(address => uint256) public shares;
    uint256 public totalShares;
    IERC20 public token;
    uint256 constant CREATE_PROPOSAL_MIN_SHARE = 1000 * 10**18;
    uint256 constant VOTING_PERIOD = 7 days;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 amount) external {
        shares[msg.sender] += amount;
        totalShares += amount;
        token.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) external {
        require(shares[msg.sender] >= amount, "Not enough shared");
        shares[msg.sender] -= amount;
        totalShares -= amount;
        token.transfer(msg.sender, amount);
    }

    function createProposal(bytes32 _hash) external {
        require(
            shares[msg.sender] >= CREATE_PROPOSAL_MIN_SHARE,
            "Not enough shared"
        );
        require(proposals[_hash].hash == bytes32(0), "Poposal already exists");
        proposals[_hash] = Proposal(
            msg.sender,
            _hash,
            0,
            0,
            Status.Undecided,
            block.timestamp
        );
    }

    function vote(bytes32 _hash, Side side) external {
        require(
            shares[msg.sender] >= CREATE_PROPOSAL_MIN_SHARE,
            "Not enough shared"
        );
        Proposal storage proposal = proposals[_hash];
        require(proposal.hash != bytes32(0), "Proposal does not exist");
        require(proposal.status == Status.Undecided, "Voting is over");
        if (proposal.createdAt > block.timestamp - VOTING_PERIOD) {
            _closeVoting(_hash);
        } else {
            require(votes[msg.sender][_hash] == false, "Already voted");
            votes[msg.sender][_hash] == true;
            if (side == Side.Yes) {
                proposal.votesYes += shares[msg.sender];
            } else {
                proposal.votesNo += shares[msg.sender];
            }
        }
    }

    function isVotingOver(bytes32 _hash) external view returns (bool) {
        return proposals[_hash].status != Status.Undecided;
    }

    function isVotingTimeOver(bytes32 _hash) external view returns (bool) {
        return proposals[_hash].createdAt > block.timestamp - VOTING_PERIOD;
    }

    function closeVoting(bytes32 _hash) external {
        require(proposals[_hash].hash != bytes32(0), "Proposal does not exist");
        require(proposals[_hash].status == Status.Undecided, "Voting is over");
        require(
            proposals[_hash].createdAt > block.timestamp - VOTING_PERIOD,
            "There is still time left to vote..."
        );
        _closeVoting(_hash);
    }

    function _closeVoting(bytes32 _hash) internal {
        Proposal storage proposal = proposals[_hash];
        if ((proposal.votesYes * 100) / totalShares > 50) {
            proposal.status = Status.Approved;
        } else {
            proposal.status = Status.Rejected;
        }
    }
}
