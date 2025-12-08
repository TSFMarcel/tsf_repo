#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────────
#  Netbird‑Installation & Konfiguration (Whiptail‑Interface)
# ────────────────────────────────────────────────────────────────────────
set -euo pipefail

# Farben & Log
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"
LOG_FILE="/var/log/netbird_setup.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') – $1" | tee -a "$LOG_FILE"; }

# 1. Netbird installieren / neu konfigurieren
log "${GREEN}NetBird‑Setup startet…${RESET}"
if command -v netbird >/dev/null 2>&1; then
    # bereits installiert – Nutzer nach Neu‑Konfiguration fragen
    if whiptail --yesno "NetBird scheint bereits installiert zu sein.\n\nMöchtest du NetBird neu konfigurieren (Reinstallieren und Service neustarten)?" 10 70; then
        log "${GREEN}Reinstalliere NetBird …${RESET}"
        sudo apt-get purge -y netbird
        sudo curl -fsSL https://pkgs.netbird.io/install.sh | sudo sh
    else
        log "${RED}NetBird-Konfiguration abgebrochen – Skript wird beendet.${RESET}"
        exit 1
    fi
else
    # nicht installiert – reguläre Installation
    log "${GREEN}Installiere NetBird …${RESET}"
    sudo curl -fsSL https://pkgs.netbird.io/install.sh | sudo sh
fi

# ggf. PATH ergänzen
if ! command -v netbird >/dev/null 2>&1; then
    export PATH=$PATH:/usr/local/bin
fi

# 2. Domain abfragen
DEFAULT_DOMAIN="netbird.vmhaus.de"
MANAGEMENT_DOMAIN=$(whiptail --inputbox "Netbird‑Management‑Domain (z. B. netbird.example.com):" \
                             10 60 --title "Netbird Domain" "$DEFAULT_DOMAIN" 3>&1 1>&2 2>&3)
if [[ $? -ne 0 || -z "$MANAGEMENT_DOMAIN" ]]; then
    log "${RED}Domain‑Eingabe abgebrochen oder leer – Netbird‑Setup wird abgebrochen.${RESET}"
    exit 1
fi
log "${GREEN}Domain eingetragen: $MANAGEMENT_DOMAIN${RESET}"

# 3. Setup‑Key abfragen
SETUP_KEY=$(whiptail --inputbox "NetbirdEncounter‑Setup‑Key:" 10 70 --title "Netbird Setup‑Key" 3>&1 1>&2 2>&3)
if [[ $? -ne 0 || -z "$SETUP_KEY" ]]; then
    log "${RED}Setup‑Key abgebrochen oder leer – Netbird‑Setup wird abgebrochen.${RESET}"
    exit 1
fi
log "${GREEN}Setup‑Key eingegeben: $SETUP_KEY${RESET}"

# 4. Netbird starten
log "${GREEN}Starte NetBird mit Management‑URL …${RESET}"
sudo netbird up --management-url "https://$MANAGEMENT_DOMAIN" --setup-key "$SETUP_KEY"
log "${GREEN}NetBird wurde erfolgreich eingerichtet.${RESET}"

# 5. IP‑Anzeige (wt0)
AGENT_IP=$(ip -4 addr show dev wt0 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1)

if [[ -z "$AGENT_IP" ]]; then
    log "${RED}Fehler: Keine IP-Adresse für Interface wt0 gefunden! Bitte wende dich an Marcel Wierich.${RESET}"
    whiptail --msgbox "Fehler: Keine IP-Adresse für Interface wt0 gefunden!\n\nBitte wende dich an Marcel Wierich." 10 60
    exit 1
else
    log "${GREEN}Agent‑IP: $AGENT_IP${RESET}"
    whiptail --msgbox "Agent‑IP: $AGENT_IP" 10 60
fi