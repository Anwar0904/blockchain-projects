# 04-DAO Voting

A decentralized autonomous organization (DAO) smart contract that allows members to create proposals, vote, and finalize results automatically.  
This project demonstrates governance, membership management, and vote tracking in Solidity.

---

## Features

- Anyone can join the DAO as a member
- Members can create proposals with descriptions and deadlines
- Members can vote yes/no on active proposals
- Each member can vote only once per proposal
- Proposals are automatically finalized after the deadline
- Proposal status tracked: Active, Passed, Failed
- Events emitted for transparency and tracking

---

## Smart Contract

- `DAOVoting.sol` → The main Solidity contract implementing DAO logic

---

## How to Use

1. Deploy `DAOVoting.sol` on Remix IDE
2. Call `joinDAO()` to become a member
3. Create proposals using `createProposal(description, durationInSeconds)`
4. Members can vote using `vote(proposalId, support)`
5. After the deadline, call `finalizeProposal(proposalId)` to conclude voting
6. View proposal details with `getProposal(proposalId)`

---

## Tech Stack

- Solidity ^0.8.28
- Ethereum Virtual Machine (EVM)
- Remix IDE (development and testing)

---

## Author

**Muhammad Anwar Ul Haq**  

This project is part of my ongoing blockchain learning journey, demonstrating DAO governance and voting mechanisms.
