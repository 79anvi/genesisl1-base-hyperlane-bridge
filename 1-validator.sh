#!/usr/bin/env bash
###############################################################################
# 1-validator.sh — RUN ON A VALIDATOR BOX, as root.
#
# Works on an EMPTY machine (installs everything, generates a key)
# or a machine where the operator ALREADY has a funded key (pass PRIVATE_KEY).
#
# USAGE (all on one line):
#   sudo N=2 MINIO_KEY=val2 MINIO_SECRET='xxxx' PRIVATE_KEY=0xabc... bash 1-validator.sh
#
#   N            = your validator number 1..5 (must match your MinIO key)
#   MINIO_KEY    = valN            (from coordinator)
#   MINIO_SECRET = your secret     (from coordinator, sent privately)
#   PRIVATE_KEY  = optional; your existing validator key. Omit to generate one.
#   BASE_RPCS    = optional; comma-separated Base RPC URLs (YOUR OWN keys).
#                  First = primary, rest = ordered failover. Overrides the
#                  public defaults in agent-config.json. Example:
#                  BASE_RPCS='https://base-mainnet.g.alchemy.com/v2/KEY,https://base-rpc.publicnode.com'
#
# What it does:
#   deps (fuse3, rclone, git, docker) -> rclone conf -> systemd FUSE mount of
#   the WHOLE bucket at /root/gl1-checkpoints -> write-through test ->
#   repo clone -> fixed agent-config.json -> .env -> docker-compose.yml
#   (localStorage syncer, path /checkpoints/validator-N/<chain>) -> start ->
#   report validator ADDRESS + funding status -> wait for self-announce.
###############################################################################
set -euo pipefail
[ "$(id -u)" = "0" ] || { echo "Run as root (sudo)."; exit 1; }

: "${N:?Set N=1..5}"
: "${MINIO_KEY:?Set MINIO_KEY=valN}"
: "${MINIO_SECRET:?Set MINIO_SECRET=...}"
PRIVATE_KEY="${PRIVATE_KEY:-}"
BASE_RPCS="${BASE_RPCS:-}"

ENDPOINT="https://checkpoints.bridge.genesisl1.org"
BUCKET="gl1-bridge-checkpoints"
MOUNT=/root/gl1-checkpoints
REPO=/root/genesisl1-base-hyperlane-bridge
GL1_RPC="https://rpc.genesisl1.org"
BASE_RPC="${BASE_RPCS%%,*}"
[ -n "$BASE_RPC" ] || BASE_RPC="https://mainnet.base.org"
IMG="gcr.io/abacus-labs-dev/hyperlane-agent:agents-v2.0.0"

echo "== [1/9] dependencies =="
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq fuse3 git curl unzip >/dev/null
command -v rclone >/dev/null || curl -s https://rclone.org/install.sh | bash >/dev/null
command -v docker >/dev/null || { curl -fsSL https://get.docker.com | sh; }
docker compose version >/dev/null 2>&1 || { echo "ERROR: docker compose plugin missing"; exit 1; }
grep -q '^user_allow_other' /etc/fuse.conf 2>/dev/null || echo 'user_allow_other' >> /etc/fuse.conf

echo "== [2/9] rclone config -> MinIO =="
mkdir -p /root/.config/rclone
cat > /root/.config/rclone/rclone.conf <<EOF
[minio]
type = s3
provider = Minio
endpoint = $ENDPOINT
access_key_id = $MINIO_KEY
secret_access_key = $MINIO_SECRET
region = us-east-1
force_path_style = true
no_check_bucket = true
no_head_object = true
EOF
chmod 600 /root/.config/rclone/rclone.conf
rclone lsd "minio:$BUCKET" --config /root/.config/rclone/rclone.conf >/dev/null \
  || { echo "ERROR: rclone cannot reach MinIO (check secret/endpoint)"; exit 1; }
echo "rclone -> MinIO OK"

echo "== [3/9] systemd FUSE mount (whole bucket) =="
cat > /etc/systemd/system/gl1-val-mount.service <<EOF
[Unit]
Description=rclone mount GL1 checkpoints (validator, whole bucket)
After=network-online.target
Wants=network-online.target
Before=docker.service snap.docker.dockerd.service

[Service]
Type=notify
ExecStartPre=/bin/mkdir -p $MOUNT
ExecStart=/usr/bin/rclone mount minio:$BUCKET $MOUNT \\
  --config /root/.config/rclone/rclone.conf \\
  --allow-other --dir-cache-time 5s --vfs-cache-mode writes --vfs-write-back 1s
ExecStartPost=/bin/sh -c 'sleep 2 && mount --make-rshared $MOUNT'
ExecStop=/bin/fusermount3 -u $MOUNT
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now gl1-val-mount.service
sleep 3
systemctl is-active --quiet gl1-val-mount.service || { journalctl -u gl1-val-mount -n 20 --no-pager; exit 1; }

echo "== [4/9] write-through test =="
TS=$(date +%s)
echo wt > "$MOUNT/validator-$N/wt-$TS.txt"
sleep 3
rclone ls "minio:$BUCKET/validator-$N/" --config /root/.config/rclone/rclone.conf | grep -q "wt-$TS.txt" \
  || { echo "ERROR: write did not reach MinIO"; exit 1; }
rm -f "$MOUNT/validator-$N/wt-$TS.txt"
echo "mount -> MinIO write-through OK"

echo "== [5/9] repo =="
[ -d "$REPO" ] || git clone -q https://github.com/GenesisL1/genesisl1-base-hyperlane-bridge.git "$REPO"

echo "== [6/9] agent-config.json (with required estimateBlockTime / IGP fields) =="
cat > "$REPO/config/agent-config.json" <<'EOF'
{
  "chains": {
    "genesisl1": {
      "name": "genesisl1", "chainId": 29, "domainId": 29, "protocol": "ethereum",
      "rpcUrls": [ { "http": "https://rpc.genesisl1.org" } ],
      "mailbox": "0xE6522A891702Cd2E8CC2A5182638c9DA1DD44B22",
      "validatorAnnounce": "0x4AEcDf823ECe5808bE25daB0987152eB87E4BC52",
      "merkleTreeHook": "0x8516B39Bca0f12f82B79065E633B8301eA5F0480",
      "interchainGasPaymaster": "0x0000000000000000000000000000000000000000",
      "index": { "from": 1 },
      "blocks": { "confirmations": 1, "reorgPeriod": 1, "estimateBlockTime": 5 }
    },
    "base": {
      "name": "base", "chainId": 8453, "domainId": 8453, "protocol": "ethereum",
      "rpcUrls": [
        { "http": "https://mainnet.base.org" },
        { "http": "https://base-rpc.publicnode.com" }
      ],
      "mailbox": "0xeA87ae93Fa0019a82A727bfd3eBd1cFCa8f64f1D",
      "validatorAnnounce": "0x182E8d7c5F1B06201b102123FC7dF0EaeB445a7B",
      "merkleTreeHook": "0x19dc38aeae620380430C200a6E990D5Af5480117",
      "interchainGasPaymaster": "0xc3F23848Ed2e04C0c6d41bd7804fa8f89F940B94",
      "index": { "from": 1 },
      "blocks": { "confirmations": 1, "reorgPeriod": 1, "estimateBlockTime": 2 }
    }
  }
}
EOF

echo "== [7/9] validator key =="
if [ -z "$PRIVATE_KEY" ]; then
  echo "No PRIVATE_KEY given -> generating a new one (foundry container)..."
  OUT=$(docker run --rm ghcr.io/foundry-rs/foundry:latest "cast wallet new" 2>/dev/null)
  PRIVATE_KEY=$(echo "$OUT" | grep -i 'Private key' | awk '{print $NF}')
  ADDR=$(echo "$OUT"       | grep -i 'Address'     | awk '{print $NF}')
  [ -n "$PRIVATE_KEY" ] || { echo "ERROR: key generation failed"; exit 1; }
  umask 077; printf 'address=%s\nprivate_key=%s\n' "$ADDR" "$PRIVATE_KEY" > /root/validator-key.txt
  echo ">>> NEW KEY saved to /root/validator-key.txt — BACK IT UP, FUND IT (see summary)."
fi

echo "== [8/9] .env + docker-compose.yml =="
cd "$REPO/validator"
umask 077
cat > .env <<EOF
HYP_VALIDATOR_KEY=$PRIVATE_KEY
HYP_CHAINS_GENESISL1_SIGNER_KEY=$PRIVATE_KEY
HYP_CHAINS_BASE_SIGNER_KEY=$PRIVATE_KEY
EOF
if [ -n "$BASE_RPCS" ]; then
  echo "HYP_CHAINS_BASE_CUSTOMRPCURLS=$BASE_RPCS" >> .env
  echo "Base RPC override set ($(echo "$BASE_RPCS" | awk -F, '{print NF}') endpoint(s), ordered failover)."
fi

cat > docker-compose.yml <<EOF
services:
  validator_genesisl1:
    image: $IMG
    container_name: fed-validator-genesisl1
    command: ./validator
    env_file: .env
    environment:
      - CONFIG_FILES=/config/agent-config.json
      - HYP_ORIGINCHAINNAME=genesisl1
      - HYP_REORGPERIOD=1
      - HYP_INTERVAL=5
      - HYP_VALIDATOR_TYPE=hexKey
      - HYP_CHAINS_GENESISL1_SIGNER_TYPE=hexKey
      - HYP_CHECKPOINTSYNCER_TYPE=localStorage
      - HYP_CHECKPOINTSYNCER_PATH=/checkpoints/validator-$N/genesisl1
      - HYP_DB=/data/validator-db
      - HYP_LOG_FORMAT=pretty
      - HYP_LOG_LEVEL=info
    user: "0:0"
    volumes:
      - ../config:/config:ro
      - ./db/validator-genesisl1:/data
      - $MOUNT:/checkpoints:rslave
    restart: unless-stopped

  validator_base:
    image: $IMG
    container_name: fed-validator-base
    command: ./validator
    env_file: .env
    environment:
      - CONFIG_FILES=/config/agent-config.json
      - HYP_ORIGINCHAINNAME=base
      - HYP_REORGPERIOD=1
      - HYP_INTERVAL=5
      - HYP_VALIDATOR_TYPE=hexKey
      - HYP_CHAINS_BASE_SIGNER_TYPE=hexKey
      - HYP_CHECKPOINTSYNCER_TYPE=localStorage
      - HYP_CHECKPOINTSYNCER_PATH=/checkpoints/validator-$N/base
      - HYP_DB=/data/validator-base
      - HYP_LOG_FORMAT=pretty
      - HYP_LOG_LEVEL=info
    user: "0:0"
    volumes:
      - ../config:/config:ro
      - ./db/validator-base:/data
      - $MOUNT:/checkpoints:rslave
    restart: unless-stopped
EOF
mkdir -p db/validator-genesisl1 db/validator-base

echo "== [9/9] start + verify =="
docker compose up -d --force-recreate
sleep 8
docker exec fed-validator-genesisl1 ls /checkpoints/ >/dev/null \
  || { echo "ERROR: container cannot see the mount"; exit 1; }

ADDR=$(docker logs fed-validator-genesisl1 2>&1 | grep -o 'eth_validator_address: 0x[0-9a-fA-F]*' | head -1 | awk '{print $2}' || true)
echo
echo "==================== SUMMARY ===================="
echo "Validator number : $N"
echo "Checkpoint store : $ENDPOINT  ->  $BUCKET/validator-$N/"
if [ -n "${ADDR:-}" ]; then
  echo "Validator ADDRESS: $ADDR   <-- SEND THIS TO THE COORDINATOR"
  for RPC in "$GL1_RPC|GenesisL1" "$BASE_RPC|Base"; do
    URL="${RPC%%|*}"; NAME="${RPC##*|}"
    BAL=$(curl -s -X POST -H 'Content-Type: application/json' \
      --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"$ADDR\",\"latest\"],\"id\":1}" \
      "$URL" | grep -o '"result":"[^"]*"' | cut -d'"' -f4 || true)
    if [ "$BAL" = "0x0" ] || [ -z "$BAL" ]; then
      echo "  $NAME balance : ZERO  -> FUND IT (GenesisL1: ~0.1 L1, Base: ~0.005 ETH)"
    else
      echo "  $NAME balance : $BAL (non-zero, OK)"
    fi
  done
else
  echo "Validator ADDRESS: (already announced, or still booting — check: docker logs fed-validator-genesisl1)"
fi
echo
echo "The agent SELF-ANNOUNCES automatically once the address is funded (one-time tx per chain)."
echo "Waiting up to 3 min for announcement.json to reach MinIO..."
for i in $(seq 1 18); do
  if rclone ls "minio:$BUCKET/validator-$N/genesisl1/" --config /root/.config/rclone/rclone.conf 2>/dev/null | grep -q announcement.json; then
    echo "SUCCESS: announcement.json is in MinIO — validator-$N is LIVE and publishing."
    exit 0
  fi
  sleep 10
done
echo "Not announced yet (probably waiting for funding). After funding, it announces itself."
echo "Re-check later:  rclone ls minio:$BUCKET/validator-$N/genesisl1/ --config /root/.config/rclone/rclone.conf"
echo "Watch logs:      docker logs -f fed-validator-genesisl1"
