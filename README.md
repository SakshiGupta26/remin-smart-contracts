# Remin Smart Contracts

A collection of Solidity smart contracts built for learning and practice.
Covers real-world use cases like voting, crowdfunding, wallets, and more.
Built with Solidity and organized for easy reading and reuse.

---

## Contracts in This Repo

| Contract | What It Does |
|---|---|
| `Voting_SmartContract.sol` | Register voters and cast votes on-chain |
| `CrowFunding_SmartContract.sol` | Raise funds with goals and deadlines |
| `Wallet_SmartContract.sol` | Simple wallet with transaction history |
| `Twitter_SmartContract.sol` | Post and read tweets stored on-chain |
| `Automotive_SmartContract.sol` | Track vehicle ownership and history |
| `erc4626-tokenized-vault/` | Yield-bearing vault using ERC-4626 standard |

---

## Folder Structure
remin-smart-contracts/
├── Voting_SmartContract.sol
├── CrowFunding_SmartContract.sol
├── Wallet_SmartContract.sol
├── Twitter_SmartContract.sol
├── Automotive_SmartContract.sol
├── erc4626-tokenized-vault/
│   ├── src/
│   │   └── MyVault.sol
│   ├── test/
│   │   └── MyVault.t.sol
│   ├── foundry.toml
│   └── remappings.txt
└── README.md

---

## Requirements

Install these before running anything:

- [Git](https://git-scm.com/downloads)
- [Remix IDE](https://remix.ethereum.org) — easiest way to run single `.sol` files
- [Foundry](https://book.getfoundry.sh/getting-started/installation) — only needed for `erc4626-tokenized-vault`
- [MetaMask](https://metamask.io) — for deploying to testnet

---

## How to Run Single Contracts (Remix — Easiest)

For all `.sol` files at the root level, use Remix IDE:

### 1. Open Remix
Go to [remix.ethereum.org](https://remix.ethereum.org)

### 2. Copy the contract
Open any `.sol` file from this repo, copy the code, paste it into a new file in Remix.

### 3. Compile
- Click **Solidity Compiler** on the left
- Select compiler version `0.8.20`
- Click **Compile**

### 4. Deploy
- Click **Deploy & Run Transactions**
- Select environment: `Remix VM` for local testing
- Click **Deploy**

### 5. Interact
Use the deployed contract panel to call functions directly.

---

## How to Run ERC-4626 Vault (Foundry)

```bash
# 1. Clone the repo
git clone https://github.com/SakshiGupta26/remin-smart-contracts.git
cd remin-smart-contracts/erc4626-tokenized-vault

# 2. Install dependencies
forge install OpenZeppelin/openzeppelin-contracts

# 3. Build
forge build

# 4. Test
forge test -vvv
```

---

## Deploy to Sepolia Testnet

### 1. Get test ETH
Visit [sepoliafaucet.com](https://sepoliafaucet.com) and paste your wallet address.

### 2. Create `.env` file
PRIVATE_KEY=your_private_key_here
RPC_URL=https://sepolia.infura.io/v3/your_infura_key

### 3. Deploy via Remix
- In Remix, change environment to **Injected Provider - MetaMask**
- Make sure MetaMask is on Sepolia network
- Click Deploy and confirm in MetaMask

---

## Contract Descriptions

### 🗳️ Voting Smart Contract
Allows an admin to register voters and candidates.
Voters can cast exactly one vote each.
Results are readable on-chain after voting ends.

### 💰 CrowFunding Smart Contract
Project creators set a funding goal and deadline.
Contributors send ETH to fund the project.
If goal is not met by deadline, contributors get refunded.

### 👛 Wallet Smart Contract
A simple on-chain wallet.
Supports deposit, withdraw, and tracks full transaction history.
Only the owner can withdraw funds.

### 🐦 Twitter Smart Contract
Users can post short messages stored on the blockchain.
Anyone can read all posts by any address.
Simulates a decentralized social media feed.

### 🚗 Automotive Smart Contract
Tracks vehicle ownership and service history on-chain.
Owner can transfer vehicle to a new address.
Full history is permanently recorded.

### 🏦 ERC-4626 Tokenized Vault
Yield-bearing vault following the ERC-4626 standard.
Deposit ERC-20 tokens, receive shares.
Shares grow in value as vault earns yield.
Includes donation attack protection via virtual offset.

---

## Common Errors & Fixes

| Error | Fix |
|---|---|
| `forge: command not found` | Install Foundry from [getfoundry.sh](https://getfoundry.sh) |
| `Compiler version mismatch` | Run `foundryup` to update |
| Contract not compiling in Remix | Check compiler version matches `pragma solidity` in file |
| MetaMask not connecting | Switch network to Sepolia in MetaMask |
| `Module not found` | Run `forge install OpenZeppelin/openzeppelin-contracts` |

---

## Learning Resources

| Topic | Link |
|---|---|
| Solidity Docs | [docs.soliditylang.org](https://docs.soliditylang.org) |
| OpenZeppelin Contracts | [docs.openzeppelin.com](https://docs.openzeppelin.com/contracts) |
| Remix IDE Guide | [remix-ide.readthedocs.io](https://remix-ide.readthedocs.io) |
| Foundry Book | [book.getfoundry.sh](https://book.getfoundry.sh) |
| ERC-4626 Standard | [ethereum.org/erc-4626](https://ethereum.org/developers/docs/standards/tokens/erc-4626/) |

---

## Author

**Sakshi Gupta**
GitHub: [@SakshiGupta26](https://github.com/SakshiGupta26)

---

## License

MIT
