#!/usr/bin/env bash
# Verify that a specific Hyperlane message has been delivered to Base.
# Usage: ./verify-delivery.sh <MESSAGE_ID>

set -euo pipefail

MSG_ID="${1:-}"

if [[ -z "$MSG_ID" ]]; then
  echo "Usage: $0 <MESSAGE_ID>"
  echo "Example: $0 0x8985299787218c808da0d4fd48380827b36d7c0b9576bebae77441f07d26ac05"
  exit 1
fi

BASE_RPC="${BASE_RPC:-https://mainnet.base.org}"
BASE_MAILBOX="0xeA87ae93Fa0019a82A727bfd3eBd1cFCa8f64f1D"

if ! command -v cast >/dev/null 2>&1; then
  echo "This script requires 'cast' from Foundry."
  echo "Install: https://getfoundry.sh"
  exit 1
fi

echo "Checking delivery of ${MSG_ID} on Base mailbox..."
DELIVERED=$(cast call --rpc-url "$BASE_RPC" "$BASE_MAILBOX" "delivered(bytes32)(bool)" "$MSG_ID")

if [[ "$DELIVERED" == "true" ]]; then
  echo "✓ Delivered"
  exit 0
else
  echo "✗ Not yet delivered"
  exit 2
fi
