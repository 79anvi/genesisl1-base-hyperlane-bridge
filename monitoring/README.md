# Monitoring

> See [../DISCLAIMER.md](../DISCLAIMER.md). Monitoring tooling here is a
> starting point and does not guarantee detection of every failure.

Basic scripts for keeping the bridge operator-alertable. Adapt them to
your alerting stack.

## Scripts

### `relayer-balance-check.sh`

Checks the relayer wallet balance on both chains against configurable
thresholds. Exits non-zero if any balance is below threshold, so it can
be wired to cron + any alerting tool (dead man's snitch, PagerDuty,
healthchecks.io, etc.).

Cron example:

```cron
*/10 * * * * /opt/hyperlane/monitoring/relayer-balance-check.sh >> /var/log/relayer-balance.log 2>&1
```

Environment variables:

- `RELAYER_ADDR` — wallet to check (default: canonical relayer)
- `BASE_MIN_WEI` — alert threshold on Base (default: 0.01 ETH)
- `GEN_MIN_WEI` — alert threshold on GenesisL1 (default: 50 L1)
- `BASE_RPC`, `GEN_RPC` — override RPC endpoints

## Roadmap

Not yet included but useful to add:

- Prometheus exporter for validator signature lag
- Dashboard showing `Dispatched` vs `Delivered` message counts per direction
- Alert when `check-collateral.sh` reports a mismatch
- Alert when the latest validator checkpoint is older than N minutes
