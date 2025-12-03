#!/usr/bin/env bash
# -------------------------------------------------------------
# Auswahl des Betriebskerns – Proxmox oder Hyper‑V
# -------------------------------------------------------------
# Farben (nur für die Konsole, nicht im Whiptail‑Fenster)
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

LOG_FILE="/var/log/first_start.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }

# ------------------------------------------------------------
# Wrapper‑Skript: Whiptail‑Installation + optionale Ausführung
# ----------------------------------------------------------------

# 1. Whiptail‑Installation (immer ausführen)
log "$GREEN Führe whiptail_install.sh aus...${RESET}"
if sudo /etc/scripts/update/whiptail_install.sh; then
    log "$GREEN Whiptail erfolgreich installiert.${RESET}"
else
    log "$RED Fehler bei whiptail_install.sh.${RESET}"
    exit 1
fi

# Auswahlmenü
CHOICE=$(whiptail --title "Umgebung auswählen" \
    --menu "Auf welchem System wird das First‑Start Skript ausgeführt?" 12 50 4 \
    "1" "Proxmox" \
    "2" "Hyper‑V" 3>&1 1>&2 2>&3)

# Abbruchbehandlung
if [ $? -ne 0 ]; then
    log "${RED}Auswahl abgebrochen – Skript beendet.${RESET}"
    exit 1
fi

case "$CHOICE" in
    1)
        SCRIPT="/etc/scripts/update/first_start_proxmox.sh"
        ENV="Proxmox"
        ;;
    2)
        SCRIPT="/etc/scripts/update/first_start_hyperv.sh"
        ENV="Hyper‑V"
        ;;
    *)
        log "${RED}Ungültige Auswahl – Skript beendet.${RESET}"
        exit 1
        ;;
esac

# Prüfen, ob das Skript vorhanden ist
if [[ ! -f "$SCRIPT" ]]; then
    log "${RED}Skript für $ENV nicht gefunden: $SCRIPT${RESET}"
    exit 1
fi

log "${GREEN}Starte First‑Start für $ENV: $SCRIPT${RESET}"
if sudo "$SCRIPT"; then
    log "${GREEN}First‑Start für $ENV abgeschlossen.${RESET}"
else
    log "${RED}Fehler beim Ausführen von $SCRIPT.${RESET}"
    exit 1
fi