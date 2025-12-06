#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────────
#  Netbird‑Installation & Konfiguration (Whiptail‑Interface)
# ────────────────────────────────────────────────────────────────────────
set -euo pipefail

# Farben für Log‑Ausgaben
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

LOG_FILE="/var/log/netbird_setup.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') – $1" | tee -a "$LOG_FILE"; }

# 1. Netbird installieren
log "${GREEN}Installiere Netbird …${RESET}"
sudo curl -fsSL https://pkgs.netbird.io/install.sh | sudo sh

# Falls das PATH noch nicht aktualisiert ist, ergänze es
if ! command -v netbird >/dev/null 2>&1; then
    export PATH=$PATH:/usr/local/bin
fi

# 2. Domain abfragen (nur falls nicht bereits angegeben)
DEFAULT_DOMAIN="netbird.vmhaus.de"
MANAGEMENT_DOMAIN=$(whiptail --inputbox "Netbird‑Management‑Domain (z. B. netbird.vmhaus.de):" \
                             10 60 \
                             --title "Netbird Domain" \
                             "$DEFAULT_DOMAIN" 3>&1 1>&2 2>&3)

if [[ $? -ne 0 || -z "$MANAGEMENT_DOMAIN" ]]; then
    log "${RED}Domain‑Eingabe abgebrochen oder leer – Netbird‑Setup wird abgebrochen.${RESET}"
    exit 1
fi
log "${GREEN}Domain eingetragen: $MANAGEMENT_DOMAIN${RESET}"

# 3. Setup‑Key abfragen (Abbruch führt zum Beenden)
SETUP_KEY=$(whiptail --inputbox "Netbird Setup‑Key:" 10 70 \
                      --title "Netbird Setup‑Key" \
                      3>&1 1>&2 2>&3)
if [[ $? -ne 0 || -z "$SETUP_KEY" ]]; then
    log "${RED}Setup‑Key abgebrochen oder leer – Netbird‑Setup wird abgebrochen.${RESET}"
    exit 1
fi
log "${GREEN}Setup‑Key eingegeben: $SETUP_KEY${RESET}"

# 4. Netbird starten
log "${GREEN}Starte Netbird mit Management‑URL …${RESET}"
sudo netbird up --management-url "https://$MANAGEMENT_DOMAIN" --setup-key "$SETUP_KEY"
log "${GREEN}Netbird wurde erfolgreich eingerichtet.${RESET}"