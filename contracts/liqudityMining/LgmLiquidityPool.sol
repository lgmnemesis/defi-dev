// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "./LgmUnderlyingToken.sol";
import "./LgmLpToken.sol";
import "./LgmGovernanceToken.sol";

contract LgmLiquidityPool is LgmLpToken("Lgm Lp Token", "LLP") {
    mapping(address => uint256) public checkpoints;
    LgmUnderlyingToken public lgmUnderlyingToken;
    LgmGovernanceToken public lgmGovernanceToken;
    uint256 public constant REWARD_PER_BLOCK = 1;

    constructor(address _underlyingToken, address _governanceToken) {
        lgmUnderlyingToken = LgmUnderlyingToken(_underlyingToken);
        lgmGovernanceToken = LgmGovernanceToken(_governanceToken);
    }

    function deposit(uint256 amount) external {
        if (checkpoints[msg.sender] == 0) {
            checkpoints[msg.sender] = block.number;
        }
        _distributeRewards(msg.sender);
        lgmUnderlyingToken.transferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Not enough LP tokens");
        _distributeRewards(msg.sender);
        lgmUnderlyingToken.transfer(msg.sender, amount);
        _burn(msg.sender, amount);
    }

    function _distributeRewards(address beneficiary) internal {
        uint256 checkpoint = checkpoints[beneficiary];
        if (block.number - checkpoint > 0) {
            uint256 distributionAmount =
                balanceOf(beneficiary) *
                    (block.number - checkpoint) *
                    REWARD_PER_BLOCK;
            lgmGovernanceToken.mint(beneficiary, distributionAmount);
            checkpoints[beneficiary] = block.number;
        }
    }
}
