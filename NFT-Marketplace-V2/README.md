# NFT Marketplace (Gas Optimized)

A minimal and production-style **ERC721 NFT Marketplace** built with **Solidity**, focused on:

* Gas efficiency
* Storage optimization
* Smart contract security
* Clean architecture

This project evolves from a **basic marketplace (Phase 2)** to a **highly optimized version (Phase 3)** using low-level Solidity techniques used in real-world DeFi/NFT protocols.

---

# Features

## Core Marketplace

* List NFTs for sale
* Buy listed NFTs
* Cancel listings
* Platform fee on each trade
* Owner withdraws collected fees

## Optimizations (Phase 3)

* Custom errors (cheaper than revert strings)
* Struct storage packing (1 slot only)
* Immutable owner
* Smaller integer types (`uint96`, `uint16`)
* Bit flags instead of booleans
* Private mappings
* Storage caching
* Checks-Effects-Interactions pattern
* Reduced SLOAD / SSTORE operations

---

# Smart Contracts

```
contracts/
 ├─ NFTMarketplace.sol            # Basic version (Phase 2)
 ├─ NFTMarketplaceOptimized.sol   # Gas optimized version (Phase 3)
```

---

# Learning Goals

This project demonstrates:

* Writing ERC721 marketplace logic
* Understanding gas costs
* Storage layout optimization
* Bitwise operations
* Security best practices
* Professional Solidity architecture

If you're learning blockchain development, this repo shows **how to refactor a working contract into a production-ready one**.

---

# Tech Stack

* Solidity ^0.8.28
* Hardhat / Foundry compatible
* ERC721 standard
* EVM

---

# Contract Design

## Listing Struct (Packed into 1 slot)

```solidity
struct Listing {
    address seller;   // 20 bytes
    uint96 price;     // 12 bytes
    uint8 flags;      // 1 byte
}
```

### Why?

Packing reduces:

* Storage slots
* Gas costs
* SSTORE operations

---

# Gas Optimization Techniques Used

## 1. Custom Errors

```solidity
error NotOwner();
error InvalidPrice();
```

Cheaper than:

```solidity
require(condition, "error message");
```

---

## 2. Immutable Variables

```solidity
address public immutable owner = msg.sender;
```

Saves gas by storing value directly in bytecode.

---

## 3. Bit Flags Instead of Bool

```solidity
uint8 private constant IS_ACTIVE = 1 << 0;
```

Multiple states inside 1 byte instead of multiple booleans.

---

## 4. Checks-Effects-Interactions

```solidity
totalFeesCollected += platformFee;
listing.flags &= ~IS_ACTIVE;
safeTransferFrom(...);
```

Prevents reentrancy attacks.

---

# How It Works

## List NFT

1. Verify ownership
2. Verify marketplace approval
3. Store listing

## Buy NFT

1. Validate price
2. Calculate platform fee
3. Update state
4. Transfer NFT
5. Pay seller

## Cancel Listing

1. Only seller or owner
2. Mark listing inactive

---

# Platform Fee

```
platformFeePercentage = 250
```

Meaning:

```
250 / 10000 = 2.5%
```

Owner can update (max 10%).

---

# Security Practices

* No external calls before state updates
* Custom errors
* Restricted owner functions
* Safe ETH transfers
* Storage minimized
* No unnecessary loops

---

# Example Usage

```solidity
listNFT(nftAddress, tokenId, 1 ether);
buyNFT{value: 1 ether}(nftAddress, tokenId);
cancelListing(nftAddress, tokenId);
withdrawFees();
```

---

# Version Comparison

| Feature         | Phase 2 | Phase 3 |
| --------------- | ------- | ------- |
| Bool flags      | ❌       | ✅       |
| Custom errors   | ❌       | ✅       |
| Struct packing  | ❌       | ✅       |
| Immutable owner | ❌       | ✅       |
| Gas optimized   | ❌       | ✅       |

---

# Future Improvements

* Auctions
* Offers/Bids
* ERC20 payments
* Royalties (ERC2981)
* Batch listings
* Off-chain signatures
* Frontend (Next.js + Wagmi)

---

# Contributing

Feel free to fork and improve.

```
git clone <repo>
npm install
npx hardhat test
```

---

# License

MIT License

---

# Author

Built as part of my **Blockchain Development Learning Journey** 
Focused on mastering **smart contract optimization and real-world Web3 engineering**.
