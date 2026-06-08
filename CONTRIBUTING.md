# Contributing

> **Before contributing, read [DISCLAIMER.md](DISCLAIMER.md) and
> [LICENSE](LICENSE).** By opening a pull request you agree that your
> contribution is licensed under the same MIT terms.

## What we need

1. **Additional validators** — currently the ISM threshold is 1/1 per
   chain. The goal is to grow to at least 3/5 for each direction. Reach
   out via the repo's Issues tab if you'd like to run a validator and have
   it included in the canonical ISM.

2. **Additional relayer operators** — the route works with a single
   relayer, but redundancy improves delivery SLA. Relayers do not require
   canonical approval; anyone can run one and deliver messages.

3. **Monitoring tooling** — Prometheus exporters, Grafana dashboards,
   alerting integrations.

4. **Documentation fixes** — if something in this repo is unclear, out of
   date, or incorrect, open a PR.

## Adding a validator to the canonical set

1. Set up a validator per
   [docs/validator-setup.md](docs/validator-setup.md).
2. Let it run for at least a week and prove reliable signing.
3. Submit the validator's announcement on-chain via
   `scripts/announce-validator.sh`.
4. Open an issue in this repo including:
   - Your validator address
   - Your publicly reachable checkpoint storage URL (must be HTTPS)
   - A link showing recent signed checkpoints at that URL
   - Rough uptime record
5. The route owner coordinates ISM redeployment after community review.
   A new ISM with your validator included will be deployed, then
   `setInterchainSecurityModule(newIsm)` called on the warp route.

## PR guidelines

- **Never commit secrets.** Do not include `.env` files, private keys, or
  anything that looks like a credential.
- **Keep docs changes in `docs/*.md`.**
- **Keep config changes in `config/*`.**
- **Test any script changes locally before submitting.**
- **Keep commit messages descriptive.** Use conventional style
  (`feat:`, `fix:`, `docs:`, `chore:`) when reasonable.

## Code of conduct

Be respectful. Operators of blockchain infrastructure are a small
community. Help when you can, ask for help when you need to, and keep
discussions technical.
