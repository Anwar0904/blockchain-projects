# CrowdRefunding Smart Contract

A decentralized crowdfunding smart contract built with Solidity.  
This contract allows anyone to create a fundraising campaign, accept ETH donations, automatically determine success or failure based on a funding goal and deadline, and securely handle withdrawals or refunds — all without intermediaries.


## Features

- Anyone can create a crowdfunding campaign
- Campaigns have a funding goal and deadline
- Users can donate ETH to active campaigns
- Campaign creator can withdraw funds if the goal is reached
- Donors can claim refunds if the campaign fails
- Secure fund handling using checks-effects-interactions pattern
- Campaign lifecycle managed using enums
- Events emitted for transparency and frontend integration


## How It Works

### Campaign Lifecycle
1. **Active**  
   - Donations are allowed  
   - No withdrawals or refunds  

2. **Successful**  
   - Funding goal reached after deadline  
   - Creator can withdraw raised ETH  

3. **Failed**  
   - Goal not reached after deadline  
   - Donors can claim refunds  

All rules are enforced automatically by the smart contract.


## Smart Contract Overview

### Campaign Data
Each campaign stores:
- Creator address
- Funding goal (in wei)
- Deadline (timestamp)
- Total raised amount
- Campaign status (Active, Successful, Failed)

### Core Functions
- `createCompaign()` → Create a new campaign
- `donate()` → Donate ETH to a campaign
- `updateStatus()` → Update campaign status after deadline
- `withdraw()` → Creator withdraws funds on success
- `refund()` → Donors refund ETH on failure
- `getCompaign()` → View campaign details


## Testing & Deployment

- Tested using **Remix IDE**
- Deployed on **local JavaScript VM**
- Compatible with testnets (Sepolia / Goerli)


## Security Considerations

- Uses `require` for input and state validation
- Prevents double withdrawals and refunds
- ETH transfers done using `.call()` for safety
- Follows best practices for state updates


## Tech Stack

- Solidity ^0.8.28
- Remix IDE
- Ethereum Virtual Machine (EVM)


##  Author

**Muhammad Anwar Ul haq**  
Blockchain & Smart Contract Learner  

This project is part of my Solidity learning journey and represents my first complete decentralized application logic built from scratch.


## License

MIT License
