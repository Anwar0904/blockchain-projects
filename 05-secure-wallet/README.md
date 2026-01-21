# Secure Wallet Smart Contract

A sophisticated, time-locked Ethereum wallet with advanced security features and emergency withdrawal mechanisms.  
This project demonstrates Phase 2 Solidity concepts including reentrancy protection, custom errors, and time-based logic.

---

## Features
- **Time-Locked Withdrawals** - Funds locked for configurable period (default: 7 days)
- **Emergency Withdrawals** - Early withdrawal option with penalty fee (default: 10%)
- **Reentrancy Protection** - Secure against reentrancy attacks
- **Pausable Operations** - Owner can pause all critical functions
- **Custom Error Handling** - Gas-efficient reverts with descriptive errors
- **Penalty System** - Configurable penalty for emergency withdrawals
- **Comprehensive Events** - Full transparency with indexed event logging

---

## Core Concepts Covered
- Modifiers (`onlyOwner`, `whenNotPaused`, `noReentrant`, `fundUnlocked`)
- ETH handling (`receive`, `fallback`, `call`)
- Contract pausability and time-based controls
- Events and logging with parameters
- Security best practices (reentrancy guard, checks-effects-interactions)
- Custom errors for gas optimization
- Time-based logic with `block.timestamp`
- Mathematical operations for penalty calculations

---

## Contract Flow
1. Owner deploys the contract with default settings (7-day lock, 10% penalty)
2. Users deposit ETH via receive(), fallback(), or deposit() function
3. Funds are time-locked for withdrawal delay period
4. Users can:
   - Withdraw normally after timelock expires
   - Emergency withdraw anytime with penalty
5. Owner can:
   - Pause/unpause contract operations
   - Adjust withdrawal delay (max 90 days)
   - Change penalty rate (max 50%)
   - Claim accumulated penalty fees
6. All actions emit events for transparency

---

## Key Functions
### User Functions:
- `deposit()` - Deposit ETH into wallet
- `withdraw(amount)` - Withdraw after timelock
- `emergencyWithdraw(amount)` - Withdraw early with penalty
- `getUnlockTime(address)` - Check unlock timestamp
- `canWithdraw(address)` - Check withdrawal eligibility

### Owner Functions:
- `setPaused(status)` - Pause/unpause contract
- `setWithdrawalDelay(seconds)` - Change timelock period
- `setEmergencyPenalty(basisPoints)` - Change penalty rate
- `claimFees()` - Withdraw penalty fees

### View Functions:
- `getBalance()` - Contract ETH balance
- `getUserBalance(address)` - User's deposited amount
- `calculateEmergencyWithdrawal(amount)` - Preview penalty

---

## Tech Stack
- Solidity ^0.8.28
- Ethereum Virtual Machine (EVM)
- Remix IDE / Hardhat for development

---

## Security Features
- Reentrancy protection on all withdrawals
- Time-locks to prevent immediate withdrawals
- Penalty system to discourage emergency withdrawals
- Owner-only administrative controls
- Maximum limits on configurable values (90 days, 50% penalty)
- Custom errors for gas efficiency and clarity

---

## Author
**Muhammad Anwar Ul Haq**  
*Blockchain Developer in Training*  
Part of Phase 2 smart contract learning journey
