
#!/bin/bash

DATEI="/etc/scripts/update/ubuntu_update.sh"

if [ -e "$DATEI" ]; then
rm "$DATEI"
sudo wget -O "$DATEI" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/ubuntu_update.sh
chmod +x "$DATEI"
else
sudo wget -O "$DATEI" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/ubuntu_update.sh
chmod +x "$DATEI"
fi

DATEI2="/etc/scripts/update/ipvlan.sh"

if [ -e "$DATEI2" ]; then
rm "$DATEI2"
sudo wget -O "$DATEI2" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/ipvlan.sh
chmod +x "$DATEI2"
else
sudo wget -O "$DATEI2" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/ipvlan.sh
chmod +x "$DATEI2"
fi

DATEI3="/etc/scripts/update/netplan_ubuntu.sh"

if [ -e "$DATEI3" ]; then
rm "$DATEI3"
sudo wget -O "$DATEI3" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/netplan_ubuntu.sh
chmod +x "$DATEI3"
else
sudo wget -O "$DATEI3" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/netplan_ubuntu.sh
chmod +x "$DATEI3"
fi

DATEI4="/etc/scripts/update/cron_job_update.sh"

if [ -e "$DATEI4" ]; then
rm "$DATEI4"
sudo wget -O "$DATEI4" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/cron_job_update.sh
chmod +x "$DATEI4"
else
sudo wget -O "$DATEI4" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/cron_job_update.sh
chmod +x "$DATEI4"
fi

DATEI5="/etc/scripts/update/first_start.sh"

if [ -e "$DATEI5" ]; then
rm "$DATEI5"
sudo wget -O "$DATEI5" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/first_start.sh
chmod +x "$DATEI5"
else
sudo wget -O "$DATEI5" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/first_start.sh
chmod +x "$DATEI5"
fi

DATEI6="/etc/scripts/update/portainer_install.sh"

if [ -e "$DATEI6" ]; then
rm "$DATEI6"
sudo wget -O "$DATEI6" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_install.sh
chmod +x "$DATEI6"
else
sudo wget -O "$DATEI6" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_install.sh
chmod +x "$DATEI6"
fi

DATEI7="/etc/scripts/update/nginx-proxy-manager.sh"

if [ -e "$DATEI7" ]; then
rm "$DATEI7"
sudo wget -O "$DATEI7" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/nginx-proxy-manager.sh
chmod +x "$DATEI7"
else
sudo wget -O "$DATEI7" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/nginx-proxy-manager.sh
chmod +x "$DATEI7"
fi

DATEI8="/etc/scripts/update/unifi-fix.sh"

if [ -e "$DATEI8" ]; then
rm "$DATEI8"
sudo wget -O "$DATEI8" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/unifi-fix.sh
chmod +x "$DATEI8"
else
sudo wget -O "$DATEI8" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/unifi-fix.sh
chmod +x "$DATEI8"
fi

DATEI9="/etc/scripts/update/speicher-erweitern.sh"

if [ -e "$DATEI9" ]; then
rm "$DATEI9"
sudo wget -O "$DATEI9" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/speicher-erweitern.sh
chmod +x "$DATEI9"
else
sudo wget -O "$DATEI9" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/speicher-erweitern.sh
chmod +x "$DATEI9"
fi

DATEI10="/etc/scripts/update/unifi_compose_converte.sh"

if [ -e "$DATEI10" ]; then
rm "$DATEI10"
sudo wget -O "$DATEI10" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/unifi_compose_converte.sh
chmod +x "$DATEI10"
else
sudo wget -O "$DATEI10" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/unifi_compose_converte.sh
chmod +x "$DATEI10"
fi

DATEI11="/etc/scripts/update/unifi_compose_update.sh"

if [ -e "$DATEI11" ]; then
rm "$DATEI11"
sudo wget -O "$DATEI11" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/unifi_compose_update.sh
chmod +x "$DATEI11"
else
sudo wget -O "$DATEI11" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/unifi_compose_update.sh
chmod +x "$DATEI11"
fi

##Herunterladen und erstellen eines Cronjobs um den Unifi Container immer wieder bei Fehler zu starten.
DATEI12="/etc/scripts/update/check_unifi.sh"

if [ -e "$DATEI12" ]; then
rm "$DATEI12"
sudo wget -O "$DATEI12" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/check_unifi.sh
chmod +x "$DATEI12"
else
sudo wget -O "$DATEI12" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/check_unifi.sh
chmod +x "$DATEI12"
fi

DATEI13="/etc/scripts/update/cron_job_update_proxmox.sh"

if [ -e "$DATEI4" ]; then
rm "$DATEI13"
sudo wget -O "$DATEI13" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/cron_job_update_proxmox.sh
chmod +x "$DATEI13"
else
sudo wget -O "$DATEI13" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/cron_job_update_proxmox.sh
chmod +x "$DATEI13"
fi

DATEI14="/etc/scripts/update/first_start_proxmox.sh"

if [ -e "$DATEI14" ]; then
rm "$DATEI14"
sudo wget -O "$DATEI14" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/first_start_proxmox.sh
chmod +x "$DATEI14"
else
sudo wget -O "$DATEI14" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/first_start_proxmox.sh
chmod +x "$DATEI14"
fi

DATEI15="/etc/scripts/update/ubuntu_update_proxmox.sh"

if [ -e "$DATEI15" ]; then
rm "$DATEI15"
sudo wget -O "$DATEI15" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/ubuntu_update_proxmox.sh
chmod +x "$DATEI15"
else
sudo wget -O "$DATEI15" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/ubuntu_update_proxmox.sh
chmod +x "$DATEI15"
fi

DATEI16="/etc/scripts/update/portainer_update_fix.sh"

if [ -e "$DATEI16" ]; then
rm "$DATEI16"
sudo wget -O "$DATEI16" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_update_fix.sh
chmod +x "$DATEI16"
else
sudo wget -O "$DATEI16" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_update_fix.sh
chmod +x "$DATEI16"
fi

DATEI17="/etc/scripts/update/first_start_hyperv.sh"

if [ -e "$DATEI17" ]; then
rm "$DATEI17"
sudo wget -O "$DATEI17" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/first_start_hyperv.sh
chmod +x "$DATEI17"
else
sudo wget -O "$DATEI17" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/first_start_hyperv.sh
chmod +x "$DATEI17"
fi

DATEI18="/etc/scripts/update/whiptail_install.sh"

if [ -e "$DATEI18" ]; then
rm "$DATEI18"
sudo wget -O "$DATEI18" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/whiptail_install.sh
chmod +x "$DATEI18"
else
sudo wget -O "$DATEI18" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/whiptail_install.sh
chmod +x "$DATEI18"
fi

DATEI19="/etc/scripts/update/portainer_edge_agent_install.sh"

if [ -e "$DATEI19" ]; then
rm "$DATEI19"
sudo wget -O "$DATEI19" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_edge_agent_install.sh
chmod +x "$DATEI19"
else
sudo wget -O "$DATEI19" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_edge_agent_install.sh
chmod +x "$DATEI19"
fi

DATEI20="/etc/scripts/update/portainer_agent_install.sh"

if [ -e "$DATEI20" ]; then
rm "$DATEI20"
sudo wget -O "$DATEI20" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_agent_install.sh
chmod +x "$DATEI20"
else
sudo wget -O "$DATEI20" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/portainer_agent_install.sh
chmod +x "$DATEI20"
fi

DATEI21="/etc/scripts/update/netbird_setup.sh"

if [ -e "$DATEI21" ]; then
rm "$DATEI21"
sudo wget -O "$DATEI21" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/netbird_setup.sh
chmod +x "$DATEI21"
else
sudo wget -O "$DATEI21" https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update/netbird_setup.sh
chmod +x "$DATEI21"
fi

# 🕒 Cronjob 1: Docker Image Prune
CRON_JOB1="0 3 * * 1 /usr/bin/docker image prune -a -f"
(crontab -l 2>/dev/null | grep -v "/usr/bin/docker image prune -a -f") | crontab -
(crontab -l 2>/dev/null; echo "$CRON_JOB1") | crontab -
echo "Cronjob wurde aktualisiert: $CRON_JOB1"

# 🔁 Cronjob 2: Speicher erweitern beim Boot
CRON_JOB2="@reboot sudo /etc/scripts/update/speicher-erweitern.sh"
(crontab -l 2>/dev/null | grep -v "/etc/scripts/update/speicher-erweitern.sh") | crontab -
(crontab -l 2>/dev/null; echo "$CRON_JOB2") | crontab -
echo "Cronjob wurde aktualisiert: $CRON_JOB2"

# 📋 Aktuelle Cronjobs anzeigen
echo "Aktuelle Cronjobs:"
crontab -l

