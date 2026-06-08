#!/usr/bin/env bash
# Simple balance check for the canonical (or configured) relayer wallet.
# Intended to be run from cron and alert when balance falls below threshold.

set -euo pipefail

RELAYER_ADDR="${RELAYER_ADDR:-0x27e4c47c4665887597ac952c0fe6ba80d096c1e2}"

# Thresholds (in wei). Below these, exit non-zero for alerting.
BASE_MIN_WEI="${BASE_MIN_WEI:-10000000000000000}"    # 0.01 ETH
GEN_MIN_WEI="${GEN_MIN_WEI:-50000000000000000000}"   # 50 L1

BASE_RPC="${BASE_RPC:-https://mainnet.base.org}"
GEN_RPC="${GEN_RPC:-https://rpc.genesisl1.org}"

json_rpc_balance() {
  local rpc="$1" addr="$2"
  local resp
  resp=$(curl -s -X POST -H "Content-Type: application/json" \
    --data "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"eth_getBalance\",\"params\":[\"$addr\",\"latest\"]}" \
    "$rpc")
  echo "$resp" | sed -nE 's/.*"result":"(0x[0-9a-fA-F]+)".*/\1/p'
}

hex_to_dec() {
  printf "%d" "$1"
}

BASE_HEX=$(json_rpc_balance "$BASE_RPC" "$RELAYER_ADDR")
GEN_HEX=$(json_rpc_balance "$GEN_RPC" "$RELAYER_ADDR")

if [[ -z "$BASE_HEX" || -z "$GEN_HEX" ]]; then
  echo "FAIL: could not read one of the RPCs"
  exit 3
fi

BASE_DEC=$(hex_to_dec "$BASE_HEX")
GEN_DEC=$(hex_to_dec "$GEN_HEX")

echo "Relayer: $RELAYER_ADDR"
echo "  Base:      $BASE_DEC wei (min $BASE_MIN_WEI)"
echo "  GenesisL1: $GEN_DEC wei (min $GEN_MIN_WEI)"

CODE=0
if (( BASE_DEC < BASE_MIN_WEI )); then
  echo "  ALERT: Base balance below threshold"
  CODE=1
fi
if (( GEN_DEC < GEN_MIN_WEI )); then
  echo "  ALERT: GenesisL1 balance below threshold"
  CODE=1
fi

exit "$CODE"
