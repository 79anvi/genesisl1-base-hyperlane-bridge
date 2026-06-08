# Hyperlane: GenesisL1 ↔ Base Bridge

Self-hostable validator and relayer configurations for the **wL1 warp route**
connecting **GenesisL1** (domain 29) and **Base** (domain 8453) via
[Hyperlane](https://hyperlane.xyz).

This repository contains everything needed to:

- Run a **validator** observing either chain and signing checkpoints.
- Run a **relayer** that delivers messages across the route.
- Verify bridge state and monitor operational health.

> ## ⚠️ READ THIS FIRST — [DISCLAIMER.md](DISCLAIMER.md)
>
> **This is open-source, decentralized, experimental software provided
> "AS-IS" with NO WARRANTY and NO LIABILITY.** There are real financial,
> technical, and smart-contract risks. By running any of the components in
> this repository or interacting with the bridge, **you accept full
> responsibility for your funds, your infrastructure, and your users.**
>
> Full terms: **[DISCLAIMER.md](DISCLAIMER.md)** — read before proceeding.

## Quick Links

- [Disclaimer](DISCLAIMER.md) ← **read before running anything**
- [Architecture overview](docs/architecture.md)
- [Deployed contracts](docs/contracts.md)
- [Validator setup guide](docs/validator-setup.md)
- [Relayer setup guide](docs/relayer-setup.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Contributing](CONTRIBUTING.md)

## Network Overview

| Chain     | Domain | Chain ID | RPC                          | Explorer                       |
| --------- | ------ | -------- | ---------------------------- | ------------------------------ |
| GenesisL1 | 29     | 29       | https://rpc.genesisl1.org    | https://explorer.genesisl1.org |
| Base      | 8453   | 8453     | https://mainnet.base.org     | https://basescan.org           |

## The Warp Route

A Hyperlane collateral/synthetic warp route for the native L1 coin, wrapped
to `wL1` (ERC-20, 18 decimals) for cross-chain transfer.

- **Collateral side** (GenesisL1): users wrap native L1 → wL1, then
  `transferRemote(8453, recipient, amount)` locks wL1 in the collateral
  router.
- **Synthetic side** (Base): relayer delivers the message, synthetic wL1 is
  minted on Base to the recipient.
- Reverse direction burns on Base and unlocks on GenesisL1.

Delivery latency: ~20–30 seconds end-to-end in normal conditions.

## Quick Start

### Run a validator

```bash
git clone https://github.com/GenesisL1/hyperlane-genesisl1-base.git
cd hyperlane-genesisl1-base/validator

cp .env.example .env
# edit .env, fill in HYP_VALIDATOR_KEY

docker compose up -d validator_genesisl1
```

See [docs/validator-setup.md](docs/validator-setup.md) for the full guide.

### Run a relayer

```bash
cd hyperlane-genesisl1-base/relayer

cp .env.example .env
# edit .env, fill in HYP_DEFAULTSIGNER_KEY

docker compose up -d
```

See [docs/relayer-setup.md](docs/relayer-setup.md) for the full guide.

## Status

| Component                          | Status                                     |
| ---------------------------------- | ------------------------------------------ |
| GenesisL1 → Base message delivery  | ✅ live                                    |
| Base → GenesisL1 message delivery  | ✅ live                                    |
| IGP on GenesisL1                   | ❌ not deployed (relayer-subsidized)       |
| IGP on Base                        | ⚠️  not wired into this route              |
| Validator diversity                | 🟡 threshold 1/1 — seeking more operators  |

## Contributing

Additional validators, relayer operators, and contributors are welcome. See
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) — with the explicit warranty and liability carve-outs in
[DISCLAIMER.md](DISCLAIMER.md). The software is provided as-is.
