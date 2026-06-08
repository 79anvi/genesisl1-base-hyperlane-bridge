# Validator

> Read [../DISCLAIMER.md](../DISCLAIMER.md) before running a validator.

See [../docs/validator-setup.md](../docs/validator-setup.md) for the full
setup guide.

## Quick start

```bash
cp .env.example .env
# edit .env — set HYP_VALIDATOR_KEY and signer keys
docker compose up -d validator_genesisl1
```

## Files

- `docker-compose.yml` — container definitions for GenesisL1 and Base
  validators
- `.env.example` — template for secrets (never commit your real `.env`)
- `signatures/` — local directory where the validator writes checkpoints.
  Must be publicly servable if other people should use your signatures.
- `db/` — local state for each validator agent

## What runs where

- `validator_genesisl1` observes the GenesisL1 mailbox, signs messages
  *originating from* GenesisL1. These signatures are what allow Base to
  accept those messages.
- `validator_base` does the same for Base-originated messages.

You can run either or both. Running both is independent — one can fail
without affecting the other.
