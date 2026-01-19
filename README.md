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

## Tech Stack
- Solidity (^0.8.28)
- Ethereum Virtual Machine (EVM)
- Remix IDE (for development and testing)
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

### 05. Secure Wallet
A security-focused Ethereum wallet smart contract with pausability and controlled withdrawals.

**Features**
- Owner-only withdrawals
- Pause and resume contract activity
- Secure ETH transfer using low-level call
- Designed with reentrancy awareness
- Event-driven transparency

**Folder**
- `04-secure-wallet`


## Author
**Muhammad Anwar Ul Haq**

This repository will continue to grow as I build and publish more blockchain projects.
