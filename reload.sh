#!/bin/bash


# Start service
echo "[*] Reloading systemd and starting SRBMiner service"
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable srbminer.service
sudo systemctl restart srbminer.service

# Delete this script after execution
rm -f "$(realpath "$0")"
