#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────────
#  Portainer‑Agent + Firewall + Fern‑Verwaltung (Whiptail‑Interface)
# ────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ------------------------------------------------------------
# 1️⃣  Log‑Setup
# ------------------------------------------------------------
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

LOG_FILE="/var/log/portainer_setup.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') – $1" | tee -a "$LOG_FILE"; }

# ------------------------------------------------------------
# 2️⃣  Portainer‑Agent Container starten
# ------------------------------------------------------------
if whiptail --yesno "Möchten Sie den Portainer Agent Container starten?" 10 60; then
    log "${GREEN}Starte Docker‑Container portainer_agent …${RESET}"
    docker run -d \
        -p 9001:9001 \
        --name portainer_agent \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /var/lib/docker/volumes:/var/lib/docker/volumes \
        -v /:/host \
        portainer/agent:2.33.5
    log "${GREEN}Container portainer_agent wurde gestartet.${RESET}"
else
    log "${RED}Installation abgebrochen.${RESET}"
    exit 0
fi

# ------------------------------------------------------------
# 3️⃣  Firewall‑Regeln setzen (Schleife)
# ------------------------------------------------------------
log "${GREEN}Konfiguriere iptables …${RESET}"
while true; do
    IP_SUBNET=$(whiptail --inputbox \
        "Geben Sie IP oder Subnetz ein (CIDR‑Format, z. B. 192.168.1.0/24), die Zugriff auf den Agent haben dürfen:" \
        10 70 --title "Netzwerk‑Eingabe" 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 || -z "$IP_SUBNET" ]]; then
        log "${RED}Eingabe abgebrochen oder leer – Regel wird nicht gesetzt.${RESET}"
    else
        log "${GREEN}Setze Regel für: $IP_SUBNET${RESET}"
        sudo iptables -I INPUT -p tcp --dport 9001 -s "$IP_SUBNET" -j ACCEPT
    fi

    if ! whiptail --yesno "Möchten Sie weitere Subnetze/IPs erlauben?" 10 60; then
        break
    fi
done

# DROP‑Regel + Persistenz
log "${GREEN}Setze DROP‑Regel für übrige Verbindungen …${RESET}"
sudo iptables -A INPUT -p tcp --dport 9001 -j DROP

if ! dpkg -s iptables-persistent >/dev/null 2>&1; then
    log "${GREEN}installiere iptables‑persistent …${RESET}"
    sudo apt-get update -qq
    sudo apt-get install -y iptables-persistent
fi

log "${GREEN}Speichere Regeln mit netfilter‑persistent …${RESET}"
sudo netfilter-persistent save
log "${GREEN}Firewall‑Regeln gespeichert und beim nächsten Booten aktiv.${RESET}"

# ------------------------------------------------------------
# 4️⃣  Fern‑Verwaltung‑Abfrage (Netbird)
# ------------------------------------------------------------
if whiptail --yesno "Soll der Agent fernverwaltet werden (Netbird‑Fern‑Verwaltung)?" 10 60; then
    SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
    if [[ -x "$SCRIPT_DIR/netbird_setup.sh" ]]; then
        "$SCRIPT_DIR/netbird_setup.sh"
    else
        log "${RED}netbird_setup.sh nicht gefunden oder nicht ausführbar!${RESET}"
        exit 1
    fi
else
    log "${GREEN}Fern‑Verwaltung abgelehnt – Setup beendet.${RESET}"
    whiptail --msgbox "Setup abgeschlossen (Agent + Firewall).${RESET}\n\nAlle Aktionen wurden protokolliert unter:\n$LOG_FILE" 12 70
    exit 0
fi

# ------------------------------------------------------------
# 5️⃣  Fertig
# ------------------------------------------------------------
whiptail --msgbox "Setup abgeschlossen!${RESET}\n\nAlle Aktionen wurden protokolliert unter:\n$LOG_FILE" 12 70