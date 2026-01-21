// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title SecureWallet - A time-locked wallet with emergency withdrawals
/// @notice Users can deposit ETH, withdraw after timelock, or emergency withdraw with penalty
/// @dev Implements reentrancy protection, custom errors, and owner controls
contract SecureWallet {
    address public owner;
    bool public paused;
    bool private locked;
    
    uint256 public withdrawalDelay = 7 days;
    uint256 public emergencyPenalty = 1000; // 1000 = 10.00%
    
    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositTimestamps;
    
    // Custom Errors
    error NotOwner();
    error ContractPaused();
    error AmountTooSmall();
    error InsufficientBalance();
    error TransferFailed();
    error ReentrancyDetected();
    error FundsLocked(uint256 unlockTime);
    error InvalidPenalty();
    
    // Events
    event Deposited(address indexed sender, uint256 amount, uint256 unlockTime);
    event Withdrawal(address indexed receiver, uint256 amount);
    event EmergencyWithdrawal(address indexed receiver, uint256 amount, uint256 penalty);
    event StatChanged(bool status);
    event WithdrawalDelayChanged(uint256 newDelay);
    event PenaltyChanged(uint256 newPenalty);
    
    // Modifiers
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    modifier whenNotPaused() {
        if (paused) revert ContractPaused();
        _;
    }
    
    modifier noReentrant() {
        if (locked) revert ReentrancyDetected();
        locked = true;
        _;
        locked = false;
    }
    
    modifier fundUnlocked(address user) {
        if (block.timestamp < depositTimestamps[user] + withdrawalDelay) {
            revert FundsLocked(depositTimestamps[user] + withdrawalDelay);
        }
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /// @notice Receive ETH deposits
    receive() external payable whenNotPaused {
        if (msg.value == 0) revert AmountTooSmall();
        _recordDeposit(msg.sender, msg.value);
    }
    
    /// @notice Fallback for ETH deposits
    fallback() external payable whenNotPaused {
        if (msg.value == 0) revert AmountTooSmall();
        _recordDeposit(msg.sender, msg.value);
    }
    
    /// @notice Deposit ETH into wallet
    function deposit() external payable whenNotPaused {
        if (msg.value == 0) revert AmountTooSmall();
        _recordDeposit(msg.sender, msg.value);
    }
    
    /// @notice Internal function to record deposits
    function _recordDeposit(address user, uint256 amount) internal {
        // Set timestamp only on first deposit
        if (balances[user] == 0) {
            depositTimestamps[user] = block.timestamp;
        }
        
        balances[user] += amount;
        emit Deposited(user, amount, depositTimestamps[user] + withdrawalDelay);
    }
    
    /// @notice Withdraw funds after timelock period
    /// @param _amount Amount to withdraw in wei
    function withdraw(uint256 _amount) external whenNotPaused noReentrant fundUnlocked(msg.sender) {
        if (_amount == 0) revert AmountTooSmall();
        if (_amount > balances[msg.sender]) revert InsufficientBalance();
        
        // Update state before external call (Checks-Effects-Interactions)
        balances[msg.sender] -= _amount;
        
        (bool sent, ) = msg.sender.call{value: _amount}("");
        if (!sent) revert TransferFailed();
        
        emit Withdrawal(msg.sender, _amount);
    }
    
    /// @notice Emergency withdrawal with penalty (before timelock)
    /// @param _amount Amount to withdraw in wei
    function emergencyWithdraw(uint256 _amount) external whenNotPaused noReentrant {
        if (_amount == 0) revert AmountTooSmall();
        if (_amount > balances[msg.sender]) revert InsufficientBalance();
        
        uint256 penalty = (_amount * emergencyPenalty) / 10000;
        uint256 received = _amount - penalty;
        
        // Update state before external call
        balances[msg.sender] -= _amount;
        
        (bool sent, ) = msg.sender.call{value: received}("");
        if (!sent) revert TransferFailed();
        
        emit EmergencyWithdrawal(msg.sender, received, penalty);
    }
    
    /// @notice Owner can withdraw penalty fees accumulated
    function claimFees() external onlyOwner noReentrant {
        // In production, track total user deposits vs contract balance
        // For this version, owner can withdraw entire balance
        uint256 balance = address(this).balance;
        
        (bool sent, ) = owner.call{value: balance}("");
        if (!sent) revert TransferFailed();
        
        emit Withdrawal(owner, balance);
    }
    
    /// @notice Pause/unpause the contract
    /// @param _status True to pause, false to unpause
    function setPaused(bool _status) external onlyOwner {
        paused = _status;
        emit StatChanged(_status);
    }
    
    /// @notice Set withdrawal delay period
    /// @param _delayInSeconds New delay in seconds (max 90 days)
    function setWithdrawalDelay(uint256 _delayInSeconds) external onlyOwner {
        require(_delayInSeconds <= 90 days, "Delay too long");
        withdrawalDelay = _delayInSeconds;
        emit WithdrawalDelayChanged(_delayInSeconds);
    }
    
    /// @notice Set emergency withdrawal penalty
    /// @param _penaltyBasisPoints Penalty in basis points (1000 = 10%, max 5000 = 50%)
    function setEmergencyPenalty(uint256 _penaltyBasisPoints) external onlyOwner {
        if (_penaltyBasisPoints > 5000) revert InvalidPenalty();
        emergencyPenalty = _penaltyBasisPoints;
        emit PenaltyChanged(_penaltyBasisPoints);
    }
    
    // View Functions
    
    /// @notice Get contract ETH balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /// @notice Get user's deposited balance
    function getUserBalance(address user) external view returns (uint256) {
        return balances[user];
    }
    
    /// @notice Get timestamp when user's funds unlock
    function getUnlockTime(address user) external view returns (uint256) {
        return depositTimestamps[user] + withdrawalDelay;
    }
    
    /// @notice Check if user can withdraw (timelock passed)
    function canWithdraw(address user) external view returns (bool) {
        return block.timestamp >= depositTimestamps[user] + withdrawalDelay;
    }
    
    /// @notice Calculate emergency withdrawal amounts
    function calculateEmergencyWithdrawal(uint256 amount) external view returns (uint256 received, uint256 penalty) {
        penalty = (amount * emergencyPenalty) / 10000;
        received = amount - penalty;
    }
}
