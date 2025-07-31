#!/bin/bash

SERVICE_FILE="/etc/systemd/system/srbminer.service"
SRB_BINARY="/opt/srbminer/SRBMiner-MULTI"

echo "[*] Updating SRBMiner service ExecStart command..."

sudo sed -i "s|^ExecStart=.*|ExecStart=$SRB_BINARY --multi-algorithm-job-mode 3 --disable-gpu --algorithm randomepic --algorithm randomx --pool 51pool.online:3416 --pool sal.kryptex.network:7777 --wallet farington#worker01 --wallet SaLvdXgjQQNC6DFxZgMEHpQ4RG6LjBynZGxrbp5kEit1YxBUoeRB81cLR2NNU43mP9DfyEPqHpf8VMNT4aXSXyefKQTLqoVMUgJ --password m=pool --password x --keepalive true --keepalive true --nicehash false --nicehash true|" "$SERVICE_FILE"

echo "[*] Reloading systemd and restarting SRBMiner..."

sudo systemctl daemon-reload
sudo systemctl restart srbminer.service

echo "[*] Done. Use 'journalctl -u srbminer -f' to monitor logs."
