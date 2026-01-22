# DeFi Staking Contract with Rewards

A decentralized staking platform where users can stake ETH and earn rewards based on time staked and APR rates. This project demonstrates advanced Solidity concepts including reward calculations, time-based logic, and secure withdrawal patterns.

## Features
- **APR-Based Rewards** - Earn interest on staked ETH (configurable rate)
- **Time-Based Calculations** - Rewards calculated per-second based on staking duration
- **Secure Withdrawals** - Reentrancy-safe withdrawal patterns
- **Pausable Contract** - Owner can pause operations in emergencies
- **Owner Controls** - Configurable parameters (APR, min/max stakes)
- **Real-time Tracking** - View pending rewards and staking stats
- **Excess Fund Recovery** - Owner can withdraw excess ETH from contract

## Phase 2 Concepts Demonstrated
- **Reward Calculation Mathematics** - APR-based interest formulas
- **Time-Based Logic** - Using `block.timestamp` for reward calculations
- **Struct & Mapping Management** - Complex data structures
- **Custom Error Handling** - Gas-efficient reverts
- **Security Patterns** - Checks-Effects-Interactions
- **Owner Access Control** - Administrative functions

## Contract Functions

### User Functions
- `stake()` - Deposit ETH to start earning rewards (payable function)
- `claimRewards()` - Claim accumulated rewards without withdrawing stake
- `withdraw(amount)` - Withdraw staked ETH along with earned rewards
- `calculateRewards(address)` - View pending rewards for any address
- `getUserInfo(address)` - View complete staking information

### Owner Functions
- `setRewardRate(newRate)` - Set APR rate (in basis points, 1000 = 10%)
- `setMinStake(amount)` - Set minimum staking amount
- `setMaxStake(amount)` - Set maximum staking amount
- `setPaused(status)` - Pause/unpause contract operations
- `withdrawExcess()` - Withdraw excess ETH from contract (emergency)

### View Functions
- `getUserInfo(address)` - Returns staked amount, stake time, pending rewards, total rewards
- `getStats()` - Returns total staked, total rewards distributed, contract balance
- `calculateAPR(amount, days)` - Calculate rewards for specific amount and duration
- `totalStaked` - Total ETH staked by all users
- `totalRewardDistributed` - Total rewards paid out

## Reward Calculation Formula
