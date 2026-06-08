#!/usr/bin/env bash
# Verify that locked collateral on GenesisL1 matches synthetic supply on Base.
# These two numbers must always be equal.

set -euo pipefail

GENESIS_RPC="${GENESIS_RPC:-https://rpc.genesisl1.org}"
BASE_RPC="${BASE_RPC:-https://mainnet.base.org}"

WL1_TOKEN_GENESIS="0x59a153c0fD47C6c1F305Abdb8030A90Aa3001fe2"
GENESIS_ROUTER="0x05cD463228768BEC155cBE9180E95652490BECF6"
WL1_TOKEN_BASE="0xE6522A891702Cd2E8CC2A5182638c9DA1DD44B22"

if ! command -v cast >/dev/null 2>&1; then
  echo "This script requires 'cast' from Foundry."
  exit 1
fi

echo "Querying locked collateral on GenesisL1..."
LOCKED=$(cast call --rpc-url "$GENESIS_RPC" "$WL1_TOKEN_GENESIS" \
  "balanceOf(address)(uint256)" "$GENESIS_ROUTER")

echo "Querying synthetic totalSupply on Base..."
SUPPLY=$(cast call --rpc-url "$BASE_RPC" "$WL1_TOKEN_BASE" \
  "totalSupply()(uint256)")

LOCKED_CLEAN=$(echo "$LOCKED" | awk '{print $1}')
SUPPLY_CLEAN=$(echo "$SUPPLY" | awk '{print $1}')

echo
echo "  Locked on GenesisL1: $LOCKED_CLEAN"
echo "  Synthetic on Base:   $SUPPLY_CLEAN"

if [[ "$LOCKED_CLEAN" == "$SUPPLY_CLEAN" ]]; then
  echo "  ✓ Match — bridge is balanced"
  exit 0
else
  echo "  ✗ MISMATCH — something is wrong, or a delivery is in flight"
  exit 2
fi
