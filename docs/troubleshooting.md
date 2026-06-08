# Troubleshooting

> See [DISCLAIMER.md](../DISCLAIMER.md). Symptoms and fixes here are
> informational; they may not cover every failure mode.

## Relayer

### Messages stuck in `PendingInclusion`

Symptom: the relayer keeps retrying the same message and never delivers.

Common causes:

- **Relayer wallet out of gas** on the destination chain. Check balance.
- **Replacement tx underpriced on Base.** Raise the EIP-1559 override
  values in `.env`.
- **Destination chain RPC returning stale state** — see HAProxy issue
  below.

### "Dropping message because recipient is not a contract"

This is a different protocol on the same mailbox using a non-contract
recipient address. Unrelated to this warp route. Ignore.

### "missing revert data" when refreshing balances

Usually rate limiting from public RPC. The bridge UI uses RPC failover
to handle this. If running scripts, retry with a different RPC or add
backoff.

### Stale RPC backend via HAProxy

If you load-balance RPC with HAProxy and one backend falls behind, it
may still pass TCP health checks but serve stale state. Symptom: relayer
logs "height in the future" errors and messages get dropped after
retries.

Fix: add an external health check script that pings `eth_blockNumber`
on each backend and pulls nodes more than N blocks behind.

## Validator

### Validator not producing signatures

Check:

- Agent logs for RPC errors
- `signatures/<chain>/` directory is writable
- `HYP_VALIDATOR_KEY` is set and valid

### Validator signed but relayer can't find signatures

Your checkpoint URL is not publicly reachable. Test from outside:

```bash
curl https://your-bucket.example.com/genesisl1/latest_index.json
```

If that fails, relayers cannot use your validator.

### Swapped validator keys by accident

Symptom: ISM rejects signatures because the announced signer doesn't
match the one signing. Fix:

1. Stop the validator.
2. Wipe
   `signatures/<chain>/{announcement,metadata_latest,index,*_with_id}.json`.
3. Set the correct `HYP_VALIDATOR_KEY`.
4. Restart. The validator will re-announce and re-sign.

## On-chain verification

### Check a specific message was delivered on Base

```bash
./scripts/verify-delivery.sh <MESSAGE_ID>
```

### Check locked collateral matches synthetic supply

```bash
./scripts/check-collateral.sh
```

If these don't match, either a delivery is in flight or something has
gone wrong. Alert the maintainers.

## GenesisL1 quirks

### `eth_estimateGas` returns errors

Known node issue. Always pass explicit `gasLimit` and `gasPrice` to
GenesisL1 transactions:

```bash
cast send \
  --rpc-url https://rpc.genesisl1.org \
  --private-key $KEY \
  --gas-limit 100000 \
  --gas-price 70000000000 \
  <contract> <function> <args>
```

Suggested limits:

- Transfer / wrap / unwrap / approve: 100,000 gas
- `transferRemote`: 500,000 gas
- Gas price: 70 gwei

### EIP-55 checksum errors in ethers v6

Ethers v6 is strict about address checksums. If you hit a "bad address
checksum" error, normalize addresses before use:

```js
const addr = ethers.getAddress(rawAddress);
```
