#!/usr/bin/env bash
# Generate a fresh validator keypair.
# Prints private key and address. Save the private key securely.

set -euo pipefail

if ! command -v cast >/dev/null 2>&1; then
  echo "This script requires 'cast' from Foundry."
  echo "Install: curl -L https://foundry.paradigm.xyz | bash && foundryup"
  exit 1
fi

WALLET_OUTPUT=$(cast wallet new)

echo "================================================================"
echo "  NEW VALIDATOR KEYPAIR"
echo "================================================================"
echo "$WALLET_OUTPUT"
echo "================================================================"
echo "  Save the private key into validator/.env as HYP_VALIDATOR_KEY"
echo "  NEVER share the private key."
echo "  The address is what goes into ISM configs."
echo "================================================================"
