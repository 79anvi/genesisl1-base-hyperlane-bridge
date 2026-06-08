# Architecture

> See [DISCLAIMER.md](../DISCLAIMER.md) for risk disclosures applicable to
> every component described here.

## Overview

This bridge uses Hyperlane's permissionless messaging layer to move the
native L1 coin (wrapped as wL1) between GenesisL1 and Base.

```
 ┌────────────────────┐                      ┌────────────────────┐
 │     GenesisL1      │                      │        Base        │
 │     (domain 29)    │                      │    (domain 8453)   │
 │                    │                      │                    │
 │   wL1 (collateral) │◀───── Hyperlane ────▶│    wL1 (synthetic) │
 │   Collateral Router│   mailbox messages   │   Synthetic Router │
 │                    │                      │                    │
 └─────────┬──────────┘                      └─────────┬──────────┘
           │                                           │
           │                                           │
     ┌─────▼──────┐                              ┌─────▼──────┐
     │  Validator │                              │  Validator │
     │   signs    │                              │   signs    │
     │ checkpoints│                              │ checkpoints│
     └─────┬──────┘                              └─────┬──────┘
           │                                           │
           └──────────────┐              ┌─────────────┘
                          ▼              ▼
                  ┌────────────────────────────────┐
                  │           Relayer              │
                  │  reads checkpoints,            │
                  │  constructs ISM metadata,      │
                  │  submits process() on          │
                  │  destination mailbox           │
                  └────────────────────────────────┘
```

## Flow: user sends wL1 from GenesisL1 to Base

1. User calls `deposit()` on wL1 (wraps native L1 into wL1).
2. User calls `approve(router, amount)` on wL1.
3. User calls `transferRemote(8453, recipient, amount)` on the collateral
   router.
4. Router locks the wL1 and calls `mailbox.dispatch(...)`, which emits a
   `Dispatch` event containing the message.
5. The **GenesisL1 validator** observes the event, signs a checkpoint
   message ID matching the dispatch, and writes the signature to its
   checkpoint storage (local filesystem / S3 / HTTPS).
6. The **relayer** reads the signed checkpoint, constructs the ISM
   metadata, and calls `process(metadata, message)` on the Base mailbox.
7. The Base mailbox verifies the signature against the ISM's validator
   set and threshold, then routes the call to the Base synthetic router,
   which mints wL1 to the recipient.

## Reverse flow: Base → GenesisL1

1. User calls `approve(router, amount)` on wL1 (on Base).
2. User calls `transferRemote(29, recipient, amount)` on the Base
   synthetic router (which is also the wL1 token contract on Base).
3. The router burns wL1 and dispatches via the Base mailbox.
4. The **Base validator** signs the checkpoint and publishes signatures.
5. The **relayer** reads signatures and calls `process(...)` on the
   GenesisL1 mailbox.
6. GenesisL1 mailbox verifies, routes to the collateral router, which
   unlocks wL1 to the recipient.
7. Recipient can `withdraw(amount)` to convert wL1 back to native L1.

## ISM configuration

Both directions use **MessageIdMultisigISM** with threshold 1.

- **ISM on Base** validates messages *from* GenesisL1. Lists the
  GenesisL1 validator.
- **ISM on GenesisL1** validates messages *from* Base. Lists the Base
  validator.

See [contracts.md](contracts.md) for addresses.

## IGP (Interchain Gas Payment)

Currently **not deployed** on GenesisL1, and **not wired** into this route
on Base. The relayer pays destination gas out of its own wallet on each
chain.

This is a bootstrap configuration. Once wL1 has a reliable price oracle, a
proper IGP will be deployed and users will quote/pay gas at send time.

For now:

- Users call `transferRemote(..., value: 0)`.
- The canonical relayer wallet on Base must stay funded with ETH.
- The canonical relayer wallet on GenesisL1 must stay funded with L1.

See [../relayer/README.md](../relayer/README.md) for the canonical relayer
wallet address and funding instructions.
