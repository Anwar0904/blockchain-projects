# Blockchain Projects

This repository contains Ethereum smart contract projects written in Solidity as part of my blockchain and smart contract learning journey.  
Each project focuses on core Ethereum concepts, best practices, and real-world use cases.

---

## Projects

### 01. Ether Wallet
A simple and secure Ethereum wallet smart contract.

**Features**
- Deposit and withdraw ETH
- Pause and unpause transactions
- Owner-based access control
- Uses modern Solidity patterns and safe ETH transfer methods

**Folder**
- `01-ether-wallet`

---

### 02. Crowd Refunding (Crowdfunding Smart Contract)
A decentralized crowdfunding smart contract that allows users to create fundraising campaigns, accept ETH donations, and handle withdrawals or refunds automatically based on campaign success or failure.

**Features**
- Anyone can create a crowdfunding campaign
- Campaigns include a funding goal and deadline
- Users can donate ETH to active campaigns
- Campaign creators can withdraw funds if the goal is reached
- Donors can claim refunds if the campaign fails
- Campaign lifecycle managed using enums
- Events emitted for transparency

**Folder**
- `02-crowd-refunding`

---

### 03. Escrow Smart Contract
A trustless escrow smart contract that securely holds ETH between a buyer and a seller until the transaction is completed or refunded.

**Features**
- Buyer creates an escrow with a specified seller and amount
- Buyer funds the escrow with ETH
- Funds are locked inside the smart contract
- Buyer can release funds to the seller
- Buyer can request a refund if the deal fails
- Escrow lifecycle managed using enums
- Secure ETH transfers using low-level call
- Events emitted for all critical actions

**Folder**
- `03-escrow-contract`

---

### 04. DAO Voting Smart Contract
A decentralized autonomous organization (DAO) smart contract that allows members to propose ideas, vote on them, and finalize outcomes automatically.

**Features**
- Anyone can join as a DAO member
- Members can create proposals with descriptions and deadlines
- Members can vote yes/no on active proposals
- Each member can vote only once per proposal
- Proposal finalized automatically after the deadline
- Proposal status: Active, Passed, or Failed
- Events emitted for all key actions for transparency

**Folder**
- `04-dao-voting`

---

### 05. Secure Wallet with Time-Lock
A security-focused Ethereum wallet smart contract with advanced time-locking and penalty features.

**Features**
- **Time-Locked Withdrawals** - Funds locked for configurable period (default: 7 days)
- **Emergency Withdrawals** - Early withdrawal option with penalty fee (default: 10%)
- **Reentrancy Protection** - Secure against reentrancy attacks
- **Pausable Operations** - Owner can pause all critical functions
- **Custom Error Handling** - Gas-efficient reverts with descriptive errors
- **Penalty System** - Configurable penalty for emergency withdrawals
- **Owner Controls** - Set withdrawal delays, penalty rates, and contract state
- **Real-time Tracking** - View unlock times and withdrawal eligibility

**Phase 2 Concepts Demonstrated**
- Custom Errors with parameters
- Reentrancy Guard implementation
- Time-based logic using `block.timestamp`
- Mathematical operations for penalty calculations
- Advanced modifier patterns

**Folder**
- `05-secure-wallet`

---

### 06. DeFi Staking Contract with Rewards
A decentralized staking platform where users can stake ETH and earn APR-based rewards.

**Features**
- **APR-Based Rewards** - Earn interest on staked ETH (configurable rate: 10% default)
- **Time-Based Calculations** - Rewards calculated per-second based on staking duration
- **Flexible Staking** - Minimum (0.01 ETH) and maximum (100 ETH) limits
- **Partial Withdrawals** - Withdraw any amount while keeping remainder staked
- **Reward Claiming** - Claim rewards without withdrawing principal
- **Owner Controls** - Adjust reward rates, limits, and pause contract
- **Excess Fund Recovery** - Owner can withdraw excess ETH from contract
- **Real-time Stats** - View total staked, rewards distributed, and user information

**Phase 2 Concepts Demonstrated**
- Reward calculation mathematics (APR formulas)
- Struct and mapping management for user data
- Complex state management
- Advanced view functions for real-time data
- Secure withdrawal patterns with Checks-Effects-Interactions

**Reward Formula**

**Folder**
- `06-Staking-contract`


---

### 07. Multi-Signature Wallet
A decentralized wallet requiring multiple approvals for transactions, similar to Gnosis Safe.

**Features**
- **M-of-N Approval System** - Configurable threshold (e.g., 2-of-3, 3-of-5)
- **Transaction Queue** - Propose, approve, and execute transactions
- **Smart Contract Support** - Execute arbitrary contract calls
- **Revocable Approvals** - Owners can change votes before execution
- **Full Transparency** - All actions logged with events
- **Secure Execution** - Reentrancy-safe transaction processing

**Technical Highlights**
- Complex transaction lifecycle management
- Nested mappings for approval tracking
- Bytes data parameter for arbitrary calls
- Custom error handling for gas efficiency
- Comprehensive event logging

**Folder**
- `07-Multi-Signature-Wallet`

---

## Author
**Muhammad Anwar Ul Haq**

This repository will continue to grow as I build and publish more blockchain projects.
