# Escrow Smart Contract

This project implements a simple Ethereum-based escrow system using Solidity.

An escrow is a trust mechanism where funds are held by a smart contract until predefined conditions are met. In this contract, a buyer deposits ETH, and the funds are either released to the seller or refunded to the buyer based on the buyer’s decision.

## Features

- Buyer creates an escrow with a seller and agreed amount
- Buyer funds the escrow with ETH
- Buyer can release funds to the seller
- Buyer can request a refund if the deal fails
- Funds are securely locked in the contract
- Clear escrow lifecycle using enums
- Event emission for all critical actions

## Escrow Flow

1. Buyer creates an escrow specifying the seller and amount
2. Buyer funds the escrow with the exact ETH amount
3. Buyer either:
   - Releases funds to the seller, or
   - Requests a refund
4. Escrow status updates accordingly

## Technologies Used

- Solidity ^0.8.28
- Ethereum
- Remix IDE

## Smart Contract

- `EscrowSmartContract.sol`

## Learning Outcomes

- Structs and enums in real use cases
- Secure ETH transfers using call
- Access control with modifiers
- State-driven contract design
- Event-driven architecture

## Notes

This project is part of my Solidity learning journey and focuses on understanding real-world smart contract patterns.
