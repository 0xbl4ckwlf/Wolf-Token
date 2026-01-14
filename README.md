# WolfToken (WOLF) 🐺
A standard ERC20 utility token built with Foundry and OpenZeppelin. This repository contains the smart contract logic, deployment scripts, and a comprehensive suite of unit tests.

## 📋 Table of Contents
1. Overview

2. Getting Started

3. Usage

4. Testing Strategy

5. Security Considerations

---
## 🔍 Overview
WolfToken is a standard implementation of the EIP-20 token standard. It utilizes OpenZeppelin's secure libraries to ensure industry-standard safety and compatibility with wallets and decentralized exchanges (DEXs).


- Token Details:

- Name: WolfToken

- Symbol: WOLF

- Decimals: 18

Initial Supply: Set via DeployWolfToken.s.sol (Standard: 1,000 WOLF)

---

## 🚀 Getting Started
### Prerequisites
- Foundry installed on your machine.

- Git for cloning the repository.

### Installation
Bash

```Bash
git clone https://github.com/0xbl4ckwlf/Smart-Contract-Lottery.git
cd Smart-Contract-Lottery
forge install
```
---

## 🛠 Usage
### Build
Compile the smart contracts to generate artifacts and ABIs:

```Bash
forge build
Deployment
```
To deploy to a local Anvil chain:
`make deploy`

To deploy to Sepolia (requires .env setup):
`make deploy-sepolia`

---

## 🧪 Testing Strategy
The codebase is covered by an extensive test suite located in test/WolfTokenTest.t.sol. We follow a multi-layered testing approach:

### 1. Unit Tests
- Metadata: Verifies Name, Symbol, and Decimals.
- Balance Logic: Ensures transfer and transferFrom update state correctly.
- Allowance: Validates the approval/spending workflow.

### 2. Edge Case & Security Tests
- Access Control: Verifies that unauthorized transferFrom calls revert.
- Sanity Checks: Tests for address(0) protection and zero-amount transfers.
- Bounds Checking: Ensures users cannot spend more than their balance or allowance.

### Running Tests
Run all tests with high verbosity to see traces:

`forge test -vvv`

---

## 🛡 Security Considerations
- OpenZeppelin 5.0: Uses the latest audited patterns for ERC20.

- Checked Transfers: Every internal transfer is verified for arithmetic safety (overflow/underflow protection).

- No Centralization: The current version features a simple fixed-supply minting in the constructor to avoid owner-only minting risks.

The tests carried out in this codebase coers the following areas:
1. Happy Path (Basic transfers and approvals)
2. Metadata (Identity check)
3. Security (Unauthorized access and insufficient funds)
4. Edge Cases (Zero and Self transfers)