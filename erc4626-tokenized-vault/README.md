# ERC-4626 Tokenized Vault

A yield-bearing vault smart contract built on the ERC-4626 standard.
Users deposit ERC-20 tokens and receive shares in return.
As the vault earns yield, each share becomes worth more tokens.
Built with Solidity + OpenZeppelin + Foundry.

---

## What This Contract Does

| Feature | Description |
|---|---|
| 📥 Deposit | Send ERC-20 tokens, get vault shares back |
| 📤 Withdraw | Burn shares, receive your tokens + yield |
| 📊 Share Price | Automatically increases as vault earns yield |
| 🛡️ Donation Attack Protection | Virtual offset prevents inflation attacks |
| 🧪 Yield Simulation | Owner can simulate yield for testing |

---

## How It Works

1. You deposit 100 USDC → you get 100 shares
2. Vault earns yield → total assets grow to 110 USDC
3. You redeem 100 shares → you get 110 USDC back

The share price goes up, not the share count.

---

## Requirements

Make sure you have these installed on your PC:

- [Git](https://git-scm.com/downloads)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

Check if Foundry is installed:
```bash
forge --version
```

---

## Installation

### 1. Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/erc4626-vault.git
cd erc4626-vault
```

### 2. Install dependencies
```bash
forge install OpenZeppelin/openzeppelin-contracts
```

### 3. Build the contract
```bash
forge build
```

If you see `Compiler run successful` — you are good to go.

---

## Run Tests
```bash
forge test
```

Run with detailed logs:
```bash
forge test -vvv
```

---

## Deploy on Sepolia Testnet

### 1. Create a `.env` file
PRIVATE_KEY=your_wallet_private_key
RPC_URL=https://sepolia.infura.io/v3/your_infura_key

### 2. Run deploy script
```bash
forge script script/Deploy.sol \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
```

---

## Project Structure
erc4626-vault/
├── src/
│   └── MyVault.sol         ← main vault contract
├── test/
│   └── MyVault.t.sol       ← tests
├── script/
│   └── Deploy.sol          ← deployment script
├── lib/
│   └── openzeppelin-contracts/
├── foundry.toml
├── remappings.txt
└── .gitignore

---

## Key Concepts to Learn

| Concept | What to Read |
|---|---|
| ERC-4626 Standard | [ethereum.org/erc-4626](https://ethereum.org/developers/docs/standards/tokens/erc-4626/) |
| OpenZeppelin Vault | [OZ ERC4626 Docs](https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#ERC4626) |
| Foundry Guide | [book.getfoundry.sh](https://book.getfoundry.sh/) |
| Inflation Attack | [OZ Blog](https://blog.openzeppelin.com/a-novel-defense-against-erc4626-inflation-attacks) |

---

## Common Errors & Fixes

| Error | Fix |
|---|---|
| `forge: command not found` | Install Foundry from [getfoundry.sh](https://getfoundry.sh) |
| `Compiler version mismatch` | Run `foundryup` to update Foundry |
| `Module not found` | Run `forge install OpenZeppelin/openzeppelin-contracts` |
| `Insufficient funds` | Get Sepolia ETH from [sepoliafaucet.com](https://sepoliafaucet.com) |

---

## License

MIT
