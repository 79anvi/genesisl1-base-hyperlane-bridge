#!/usr/bin/env bash
# Submit a validator's announcement to the ValidatorAnnounce contract.
# Usage: ./announce-validator.sh <chain> <path-to-announcement.json>
#
# <chain> is one of: genesisl1, base

set -euo pipefail

CHAIN="${1:-}"
ANNOUNCEMENT_FILE="${2:-}"

if [[ -z "$CHAIN" || -z "$ANNOUNCEMENT_FILE" ]]; then
  echo "Usage: $0 <chain> <path-to-announcement.json>"
  echo "Example: $0 genesisl1 ./signatures/genesisl1/announcement.json"
  exit 1
fi

if [[ ! -f "$ANNOUNCEMENT_FILE" ]]; then
  echo "Announcement file not found: $ANNOUNCEMENT_FILE"
  exit 1
fi

case "$CHAIN" in
  genesisl1)
    RPC="${GENESIS_RPC:-https://rpc.genesisl1.org}"
    VA="0x4AEcDf823ECe5808bE25daB0987152eB87E4BC52"
    EXTRA_ARGS="--gas-limit 200000 --gas-price 70000000000"
    ;;
  base)
    RPC="${BASE_RPC:-https://mainnet.base.org}"
    VA="0x182E8d7c5F1B06201b102123FC7dF0EaeB445a7B"
    EXTRA_ARGS=""
    ;;
  *)
    echo "Unknown chain: $CHAIN"
    exit 1
    ;;
esac

if [[ -z "${VALIDATOR_KEY:-}" ]]; then
  echo "Set VALIDATOR_KEY in env (the private key paying for announce)."
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "This script requires 'jq'."
  exit 1
fi

if ! command -v cast >/dev/null 2>&1; then
  echo "This script requires 'cast' from Foundry."
  exit 1
fi

VALIDATOR=$(jq -r '.validator' "$ANNOUNCEMENT_FILE")
STORAGE_LOCATION=$(jq -r '.storage_location' "$ANNOUNCEMENT_FILE")
SIGNATURE=$(jq -r '.signature' "$ANNOUNCEMENT_FILE")

echo "Announcing validator $VALIDATOR to $CHAIN ValidatorAnnounce ($VA)..."
echo "Storage location: $STORAGE_LOCATION"

# shellcheck disable=SC2086
cast send --rpc-url "$RPC" --private-key "$VALIDATOR_KEY" $EXTRA_ARGS \
  "$VA" \
  "announce(address,string,bytes)" \
  "$VALIDATOR" "$STORAGE_LOCATION" "$SIGNATURE"

echo "✓ Announced."
