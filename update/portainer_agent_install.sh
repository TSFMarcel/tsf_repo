#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────────
#  Portainer‑Agent + Fern‑Verwaltung (Whiptail‑Interface)
# ────────────────────────────────────────────────────────────────────────
set -euo pipefail

# ─── Log‑Setup ───────────────────────────────────────────────────────
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"
LOG_FILE="/var/log/portainer_setup.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') – $1" | tee -a "$LOG_FILE"; }

# ── Portainer‑Agent Container starten ─────────────────────────────────
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

# ── Fern‑Verwaltung‑Abfrage (Netbird) ─────────────────────────────────
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
    whiptail --msgbox "Setup abgeschlossen (Agent).${RESET}\n\nAlle Aktionen wurden protokolliert unter:\n$LOG_FILE" 12 70
    exit 0
fi

# ── Fertig ─────────────────────────────────────────────────────────────
whiptail --msgbox "Setup abgeschlossen!${RESET}\n\nAlle Aktionen wurden protokolliert unter:\n$LOG_FILE" 12 70