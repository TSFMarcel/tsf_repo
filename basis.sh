
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

DATEI2="/etc/scripts/ipvlan.sh"

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
sudo wget -O "$DATEI3" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/netplan_ubuntu.sh
chmod +x "$DATEI3"
else
sudo wget -O "$DATEI3" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/netplan_ubuntu.sh
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

DATEI5="/etc/scripts/first_start.sh"

if [ -e "$DATEI5" ]; then
rm "$DATEI5"
sudo wget -O "$DATEI5" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/first_start.sh
chmod +x "$DATEI5"
else
sudo wget -O "$DATEI5" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/first_start.sh
chmod +x "$DATEI5"
fi

DATEI6="/etc/scripts/portainer_install.sh"

if [ -e "$DATEI6" ]; then
rm "$DATEI6"
sudo wget -O "$DATEI6" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/portainer_install.sh
chmod +x "$DATEI6"
else
sudo wget -O "$DATEI6" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/portainer_install.sh
chmod +x "$DATEI6"
fi

DATEI7="/etc/scripts/nginx-proxy-manager.sh"

if [ -e "$DATEI7" ]; then
rm "$DATEI7"
sudo wget -O "$DATEI7" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/nginx-proxy-manager.sh
chmod +x "$DATEI7"
else
sudo wget -O "$DATEI7" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/nginx-proxy-manager.sh
chmod +x "$DATEI7"
fi

DATEI8="/etc/scripts/unifi-fix.sh"

if [ -e "$DATEI8" ]; then
rm "$DATEI8"
sudo wget -O "$DATEI8" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/unifi-fix.sh
chmod +x "$DATEI8"
else
sudo wget -O "$DATEI8" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/unifi-fix.sh
chmod +x "$DATEI8"
fi

DATEI9="/etc/scripts/speicher-erweitern.sh"

if [ -e "$DATEI9" ]; then
rm "$DATEI9"
sudo wget -O "$DATEI9" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/speicher-erweitern.sh
chmod +x "$DATEI9"
else
sudo wget -O "$DATEI9" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/speicher-erweitern.sh
chmod +x "$DATEI9"
fi

# 🕒 Cronjob 1: Docker Image Prune
CRON_JOB1="0 3 * * 1 /usr/bin/docker image prune -a -f"
(crontab -l 2>/dev/null | grep -v "/usr/bin/docker image prune -a -f") | crontab -
(crontab -l 2>/dev/null; echo "$CRON_JOB1") | crontab -
echo "Cronjob wurde aktualisiert: $CRON_JOB1"

# 🔁 Cronjob 2: Speicher erweitern beim Boot
CRON_JOB2="@reboot sudo /etc/scripts/speicher-erweitern.sh"
(crontab -l 2>/dev/null | grep -v "/etc/scripts/speicher-erweitern.sh") | crontab -
(crontab -l 2>/dev/null; echo "$CRON_JOB2") | crontab -
echo "Cronjob wurde aktualisiert: $CRON_JOB2"

# 📋 Aktuelle Cronjobs anzeigen
echo "Aktuelle Cronjobs:"
crontab -l

