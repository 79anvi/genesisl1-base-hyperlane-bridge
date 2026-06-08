# Relayer

> Read [../DISCLAIMER.md](../DISCLAIMER.md) before running a relayer.

See [../docs/relayer-setup.md](../docs/relayer-setup.md) for the full
setup guide.

## Quick start

```bash
cp .env.example .env
# edit .env — set HYP_DEFAULTSIGNER_KEY
docker compose up -d
docker compose logs -f relayer
```

## Wallet funding

The relayer wallet (derived from `HYP_DEFAULTSIGNER_KEY`) must hold:

- **ETH on Base** — pays gas for every delivery to Base
- **L1 on GenesisL1** — pays gas for every delivery to GenesisL1

Recommended minimum balances:

- Base: 0.05 ETH
- GenesisL1: 100 L1

Check and refill regularly. See
[../monitoring/relayer-balance-check.sh](../monitoring/relayer-balance-check.sh).

## Files

- `docker-compose.yml` — container definition, includes the EIP-1559 gas
  overrides required on Base
- `.env.example` — template for your signer key
- `db/` — relayer state
