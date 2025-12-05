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
cd SRBMiner-MULTI*/ || exit

# Make executable
chmod +x SRBMiner-MULTI

# Run miner in background
./SRBMiner-MULTI \
  --multi-algorithm-job-mode 3 \
  --disable-gpu \
  --algorithm randomepic \
  --algorithm randomx \
  --pool 51pool.online:3416 \
  --pool sal.kryptex.network:7028 \
  --wallet farington#Worker01 \
  --wallet SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm/Worker03 \
  --password Worker01 \
  --password none \
  --keepalive true \
  --keepalive true \
  --nicehash false \
  --nicehash true \
  &>/tmp/srbminer.log &
