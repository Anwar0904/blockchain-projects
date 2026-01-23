# Multi-Signature Wallet

A secure, decentralized multi-signature wallet smart contract requiring multiple approvals for transactions. This project demonstrates advanced access control, transaction queuing, and secure execution patterns used by DAOs and corporate treasuries.

## Features
- **Multi-Owner Control** - Multiple addresses can manage the wallet
- **M-of-N Approvals** - Configurable approval threshold (e.g., 2-of-3, 3-of-5)
- **Transaction Queuing** - Propose, approve, and execute transactions
- **Revocable Approvals** - Owners can revoke confirmations before execution
- **Smart Contract Calls** - Execute arbitrary contract calls, not just ETH transfers
- **Full Transparency** - All actions logged with indexed events
- **Secure Execution** - Checks-Effects-Interactions pattern to prevent reentrancy

## How It Works
1. **Setup** - Deploy wallet with list of owners and required confirmations
2. **Proposal** - Any owner can submit a transaction
3. **Approval** - Other owners confirm the transaction
4. **Execution** - When enough confirmations are reached, any owner can execute
5. **Optional** - Owners can revoke confirmations before execution

## Contract Functions

### Core Functions
- `submitTransaction(address to, uint256 value, bytes memory data)` - Propose new transaction
- `confirmTransaction(uint256 txIndex)` - Approve a pending transaction
- `executeTransaction(uint256 txIndex)` - Execute approved transaction
- `revokeConfirmation(uint256 txIndex)` - Revoke approval before execution

### View Functions
- `getOwners()` - Returns list of all owners
- `getTransactionCount()` - Returns number of transactions
- `getTransaction(uint256 txIndex)` - Returns transaction details
- `isConfirmed(uint256 txIndex, address owner)` - Check if owner approved transaction

### Admin Functions
- Constructor accepts owners array and required confirmations
- Built-in access control via `onlyOwner` modifier

## Smart Contract Calls
The wallet can execute arbitrary contract calls using `bytes data` parameter:
- Transfer ERC20 tokens
- Interact with DeFi protocols
- Call other smart contracts
- Simple ETH transfers (use empty `data`)

## Security Features
- **Reentrancy Protection** - State updates before external calls
- **Input Validation** - All parameters validated
- **Access Control** - Only owners can perform actions
- **No Single Point of Failure** - Requires multiple approvals
- **Immutable Owners** - Owners list set at deployment

## Deployment Example
```solidity
// Deploy with 3 owners requiring 2 confirmations
address[] memory owners = new address[](3);
owners[0] = 0xOwner1;
owners[1] = 0xOwner2;
owners[2] = 0xOwner3;
uint256 requiredConfirmations = 2;

MultiSigWallet wallet = new MultiSigWallet(owners, requiredConfirmations);
