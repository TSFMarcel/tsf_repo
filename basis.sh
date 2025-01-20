
#!/bin/bash

DATEI="/etc/scripts/ubuntu_update.sh"

if [ -e "$DATEI" ]; then
rm "$DATEI"
sudo wget -O "$DATEI" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/ubuntu_update.sh
chmod +x "$DATEI"
else
sudo wget -O "$DATEI" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/ubuntu_update.sh
chmod +x "$DATEI"
fi

DATEI2="/etc/scripts/ipvlan_ubuntu.sh"

if [ -e "$DATEI2" ]; then
rm "$DATEI2"
sudo wget -O "$DATEI2" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/ipvlan.sh
chmod +x "$DATEI2"
else
sudo wget -O "$DATEI2" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/ipvlan.sh
chmod +x "$DATEI2"
fi

DATEI3="/etc/scripts/netplan_ubuntu.sh"

if [ -e "$DATEI3" ]; then
rm "$DATEI3"
sudo wget -O "$DATEI3" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/netplan.sh
chmod +x "$DATEI3"
else
sudo wget -O "$DATEI3" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/netplan.sh
chmod +x "$DATEI3"
fi

DATEI4="/etc/scripts/cron_job_update.sh"

if [ -e "$DATEI4" ]; then
rm "$DATEI4"
sudo wget -O "$DATEI4" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/cron_job_update.sh
chmod +x "$DATEI4"
else
sudo wget -O "$DATEI4" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/cron_job_update.sh
chmod +x "$DATEI4"
fi
