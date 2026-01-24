# NFT Marketplace

A decentralized NFT marketplace smart contract supporting fixed-price listings and secure transactions. This project demonstrates ERC721 integration, fee management, and secure payment handling.

## Features
- **Fixed-Price Listings** - List NFTs at specific prices
- **Secure Transactions** - Built-in reentrancy protection
- **Fee System** - Configurable platform fees (default 2.5%)
- **Multi-Collection Support** - Works with any ERC721 NFT
- **Approval System** - Standard ERC721 approval patterns
- **Full Transparency** - Comprehensive event logging
- **Owner Controls** - Adjustable platform settings

## Contract Functions

### User Functions
- `listNFT(address nftAddress, uint256 tokenId, uint256 price)` - List NFT for sale
- `buyNft(address nftAddress, uint256 tokenId)` - Purchase listed NFT
- `cancelListing(address nftAddress, uint256 tokenId)` - Cancel active listing

### Owner Functions
- `setPlatformFee(uint256 newFeePercentage)` - Update platform fee (max 10%)
- `withdrawFees()` - Withdraw accumulated platform fees

### View Functions
- `listings(address nftAddress, uint256 tokenId)` - View listing details
- `listingCount` - Total active listings
- `totalFeesCollected` - Total platform fees earned

## How It Works

### 1. Listing Process
```solidity
// User must:
1. Own the NFT
2. Approve marketplace to transfer NFT
3. Call listNFT() with price

// Marketplace:
1. Validates ownership
2. Checks approval status
3. Creates listing record
