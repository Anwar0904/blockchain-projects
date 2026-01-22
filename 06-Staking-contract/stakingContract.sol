// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract StakingContract {
    address public owner;
    bool public paused;
    uint256 public rewardRate = 1000;
    uint256 public minStake = 0.01 ether;
    uint256 public maxStake = 100 ether;

    uint256 public totalStaked;
    uint256 public totalRewardsDistributed;

    mapping(address => Staker) public stakers;
    
    error NotOwner();
    error ContractPaused();
    error AmountTooSmall();
    error AmountTooLarge();
    error NoStakeFound();
    error RewardsNotAvailable();

    struct Staker {
        uint256 amount;
        uint256 stakeTime;
        uint256 lastClaimTime;
        uint256 totalRewards;
    }

    event Staked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);
    event RewardRateChanged(uint256 newRate);
    event ContractPausedStatus(bool paused);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier whenNotPaused() {
        if (paused) revert ContractPaused();
        _;
    }

    function calculateRewards(address stakerAddress) public view returns (uint256 rewards) {
        Staker memory staker = stakers[stakerAddress];
        if (staker.amount == 0) return 0;

        uint256 timeStaked = block.timestamp - staker.lastClaimTime;
        rewards = (staker.amount * timeStaked * rewardRate) / (365 days * 10000);
    }

    function stake() external payable whenNotPaused {
        if (msg.value < minStake) revert AmountTooSmall();
        if (msg.value > maxStake) revert AmountTooLarge();
       
        Staker storage staker = stakers[msg.sender];

        if (staker.amount == 0) {
            staker.stakeTime = block.timestamp;
            staker.lastClaimTime = block.timestamp;
        } else {
            uint256 pending = calculateRewards(msg.sender);
            staker.totalRewards += pending;
            staker.lastClaimTime = block.timestamp;
        }
        
        staker.amount += msg.value;
        totalStaked += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    function claimRewards() external whenNotPaused {
        Staker storage staker = stakers[msg.sender];

        if (staker.amount == 0) revert NoStakeFound();
        
        uint256 pendingRewards = calculateRewards(msg.sender);

        if (pendingRewards == 0) revert RewardsNotAvailable();

        staker.totalRewards += pendingRewards;
        staker.lastClaimTime = block.timestamp;

        totalRewardsDistributed += pendingRewards;

        (bool sent, ) = msg.sender.call{value: pendingRewards}("");
        require(sent, "Transaction Failed");

        emit RewardClaimed(msg.sender, pendingRewards);
    }

    function withdraw(uint256 amount) external whenNotPaused {
        Staker storage staker = stakers[msg.sender];

        if (staker.amount == 0) revert NoStakeFound();
        if (amount == 0 || amount > staker.amount) revert AmountTooSmall();

        uint256 pendingRewards = calculateRewards(msg.sender);
        uint256 totalToSend = amount;
        
        if (pendingRewards > 0) {
            totalToSend += pendingRewards;
            staker.totalRewards += pendingRewards;
            totalRewardsDistributed += pendingRewards;
        }

        staker.amount -= amount;
        staker.lastClaimTime = block.timestamp;

        if (staker.amount == 0) {
            staker.stakeTime = 0;
        }

        totalStaked -= amount;

        (bool sent, ) = msg.sender.call{value: totalToSend}("");
        require(sent, "Transaction Failed");

        emit Withdrawn(msg.sender, amount, pendingRewards);
    }

    // Pause function
    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
        emit ContractPausedStatus(_paused);
    }

    function setRewardRate(uint256 newRate) external onlyOwner {
        require(newRate <= 5000, "Rate too high");
        rewardRate = newRate;
        emit RewardRateChanged(newRate);
    }

    function setMinStake(uint256 newMinStake) external onlyOwner {
        minStake = newMinStake;
    }
    
    function setMaxStake(uint256 newMaxStake) external onlyOwner {
        maxStake = newMaxStake;
    }

    function withdrawExcess() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        uint256 requiredBalance = totalStaked;

        require(contractBalance > requiredBalance, "No excess funds");

        uint256 excessFund = contractBalance - requiredBalance;
        
        (bool sent, ) = owner.call{value: excessFund}("");
        require(sent, "Transaction Failed");
    }

    // View functions 
    function getUserInfo(address user) external view returns (
        uint256 stakedAmount,
        uint256 stakeTime,
        uint256 pendingRewards,
        uint256 totalEarnedRewards
    ) {
        Staker storage staker = stakers[user];
        return (
            staker.amount,
            staker.stakeTime,
            calculateRewards(user),
            staker.totalRewards
        );
    }

    function getStats() external view returns (
        uint256 _totalStaked,
        uint256 _totalRewardsDistributed,
        uint256 _contractBalance
    ) {
        return (
            totalStaked,
            totalRewardsDistributed,
            address(this).balance
        );
    }

    function calculateAPR(uint256 amount, uint256 stakedDays) external view returns (uint256) {
        return (amount * rewardRate * stakedDays) / (365 * 10000);
    }
}
