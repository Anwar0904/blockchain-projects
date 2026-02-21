# DexWithOracle Project

## Overview

**DexWithOracle** is a simplified decentralized exchange (DEX) smart contract written in Solidity. It implements a constant product Automated Market Maker (AMM) model and integrates a Chainlink price oracle to protect users from excessive price deviations.

This project is designed for educational and experimental purposes to demonstrate how on-chain liquidity pools can be combined with external price feeds for basic price validation and risk control.

---

## Key Features

* Constant product AMM model (`x * y = k`)
* Chainlink price feed integration
* Price deviation protection mechanism
* Owner-controlled liquidity management
* Pause and unpause functionality
* Event logging for swaps and liquidity actions

---

## Smart Contract Architecture

### State Variables

* `owner` – Address of the contract deployer
* `reserveA` – Reserve of token A
* `reserveB` – Reserve of token B
* `priceFeed` – Chainlink AggregatorV3Interface
* `maxDeviation` – Maximum allowed price deviation (default 5%)
* `paused` – Emergency pause flag

---

## Oracle Integration

The contract uses the Chainlink `AggregatorV3Interface` to fetch the latest ETH/USD price.

* `getOraclePrice()`
  Retrieves the latest oracle price and normalizes it to 18 decimals.

* `getPoolPrice()`
  Calculates the current on-chain price of token A in terms of token B.

* `getDeviation()`
  Computes the percentage difference between the oracle price and the pool price.

If deviation exceeds `maxDeviation`, swaps are blocked.

---

## Liquidity Management

### addLiquidity(uint256 amountA, uint256 amountB)

* Only callable by the owner
* Sets the pool reserves
* Designed for simplified testing
* Emits `LiquidityAdded`

Note: This implementation overwrites reserves instead of adding to them. It is intentionally simplified.

---

## Swapping Mechanism

The contract follows the standard constant product formula:

k = reserveA * reserveB

### swapAforB(uint amountAIn)

* User provides token A

* Calculates output using:

  newReserveA = reserveA + amountAIn
  newReserveB = k / newReserveA
  amountBOut = reserveB - newReserveB

* Enforces deviation check

* Updates reserves

* Emits `Swapped`

### swapBforA(uint amountBIn)

* User provides token B
* Same constant product logic applied
* Enforces deviation check
* Updates reserves
* Emits `Swapped`

---

## Security Controls

### Price Deviation Guard

All swaps use the `priceWithRange` modifier:

* Ensures the contract is not paused
* Ensures deviation from oracle price is within allowed range

This mechanism helps protect against:

* Flash loan manipulation
* Extreme price imbalance
* Arbitrage attacks exploiting thin liquidity

### Pause Mechanism

* `pause()` – Only owner
* `unpause()` – Only owner

Allows emergency stop of swap operations.

---

## Events

* `Swapped`
* `LiquidityAdded`
* `Paused`
* `Unpaused`

These events allow off-chain monitoring and analytics.

---

## Limitations

This contract is intentionally simplified and should not be used in production. Key limitations include:

* No ERC20 token transfers
* No liquidity tokens (LP tokens)
* No fee mechanism
* No slippage protection for users
* No reentrancy protection
* Reserves can be overwritten by owner
* No safe math validation beyond Solidity 0.8 overflow checks

---

## Suggested Improvements

If you want to evolve this into a more production-ready system, consider the following upgrades:

### 1. Add ERC20 Token Support

Integrate actual token transfers using `IERC20` instead of manually managing reserve variables.

### 2. Implement Liquidity Provider (LP) Tokens

Mint LP tokens to represent ownership share of the pool.

### 3. Introduce Swap Fees

Add a fee mechanism (e.g., 0.3%) similar to Uniswap to reward liquidity providers.

### 4. Add Slippage Protection

Allow users to specify a minimum output amount to prevent unfavorable trades.

### 5. Reentrancy Protection

Use OpenZeppelin’s `ReentrancyGuard` to secure swap functions.

### 6. TWAP Instead of Instant Price Check

Instead of checking the latest oracle price, consider implementing time-weighted average price validation.

### 7. Improve Liquidity Logic

Modify `addLiquidity()` to:

* Maintain price ratio
* Add proportional liquidity
* Prevent reserve overwrite

### 8. Add Remove Liquidity Function

Allow LPs to withdraw funds proportionally.

### 9. Use Safe Oracle Handling

Add additional checks such as:

* Stale price validation
* Round completeness verification

### 10. Gas Optimization

Consider caching frequently used state variables locally in functions.

---

## Educational Value

This project demonstrates:

* How constant product AMMs work
* How to integrate Chainlink price feeds
* How to design price deviation guards
* How to apply modifiers for security constraints

It is a strong foundational exercise for understanding DeFi protocol architecture before moving toward more complex systems like Uniswap-style DEXs.

---

## Disclaimer

This smart contract is for educational and testing purposes only. It has not been audited and should not be deployed to mainnet without significant security improvements.
