# Secure Wallet Smart Contract

A secure Ethereum wallet smart contract demonstrating access control, pausability, and safe ETH withdrawal patterns.  
This project is part of my Phase 2 smart contract learning journey, focusing on security-aware contract design.

---

## Features
- Owner-based access control
- Deposit ETH via receive, fallback, or explicit deposit function
- Withdraw ETH securely using low-level call
- Pause and unpause contract functionality
- Emits events for transparency and tracking
- Designed with reentrancy awareness

---

## Core Concepts Covered
- Modifiers (`onlyOwner`, `whenNotPaused`)
- ETH handling (`receive`, `fallback`, `call`)
- Contract pausability
- Events and logging
- Security best practices
- Understanding why system balance can be safely used

---

## Contract Flow
1. Owner deploys the contract
2. Users deposit ETH into the contract
3. Owner can pause/unpause withdrawals
4. Owner withdraws ETH securely
5. Events log all major actions

---

## Tech Stack
- Solidity ^0.8.x
- Ethereum Virtual Machine (EVM)
- Remix IDE

---

## Author
**Muhammad Anwar Ul Haq**
