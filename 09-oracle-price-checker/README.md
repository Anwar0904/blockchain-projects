# Oracle Price Checker

## Overview

Oracle Price Checker is a Solidity smart contract that integrates a Chainlink ETH/USD price feed to retrieve real-time price data on-chain.

The project demonstrates how decentralized applications (dApps) can securely consume external data using Chainlink oracles. It also includes functionality to compare the current market price against a user-defined target price.

This project is deployed and tested on the Ethereum Sepolia test network.

---

## Features

* Integration with Chainlink ETH/USD price feed
* Fetch raw oracle price
* Normalize price to 18 decimals
* Store a custom target price
* Compare live price against target
* Calculate absolute price difference

---

## Smart Contract

Contract: `OraclePriceChecker.sol`

The contract:

* Connects to a Chainlink Aggregator contract
* Reads price data using `latestRoundData()`
* Handles oracle decimal conversion
* Performs price comparison logic

---

## Network Configuration

Network: Ethereum Sepolia Testnet

Chainlink ETH/USD Feed (Sepolia):
`0x694AA1769357215DE4FAC081bf1f309aDC325306`

---

## How It Works

1. The contract is deployed with the Chainlink price feed address.
2. It calls `latestRoundData()` from the Aggregator interface.
3. The returned price (usually 8 decimals) is converted to 18 decimals.
4. A user can set a target price.
5. The contract compares real-time ETH price with the stored target.

---

## Deployment Guide (Remix + MetaMask)

1. Open Remix IDE.
2. Paste the contract into a new file.
3. Compile using Solidity version 0.8.28.
4. Select "Injected Provider - MetaMask".
5. Switch MetaMask network to Sepolia.
6. Deploy using the Sepolia ETH/USD feed address as constructor argument.

---

## Learning Objectives

This project demonstrates:

* Smart contract interaction with external protocols
* Oracle integration using Chainlink
* Handling decimal precision in Solidity
* Writing production-style Solidity code
* Secure price comparison logic

---

## Security Notes

* The contract checks for invalid oracle prices.
* Target price must be greater than zero.
* Price values are normalized to 18 decimals for consistency.

For production use, additional checks such as stale price validation should be implemented.

---

## Future Improvements

* Add stale price protection
* Add access control for setting target price
* Deploy on Ethereum Mainnet
* Integrate into a DeFi protocol
* Add frontend using ethers.js

---

## Author

Anwar Ulhaq
Blockchain Developer (Learning Phase)

