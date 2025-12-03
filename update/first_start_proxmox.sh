#!/usr/bin/env bash
# ------------------------------------------------------------
# Wrapper‑Skript: Whiptail‑Installation + optionale Ausführung
# ----------------------------------------------------------------

# Farben
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Log‑Datei
LOG_FILE="/var/log/setup_all.log"
mkdir -p "$(dirname "$LOG_FILE")"

log() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }

# 1. Whiptail‑Installation (immer ausführen)
log "$GREEN Führe whiptail_install.sh aus...${RESET}"
if sudo /etc/scripts/whiptail_install.sh; then
    log "$GREEN Whiptail erfolgreich installiert.${RESET}"
else
    log "$RED Fehler bei whiptail_install.sh.${RESET}"
    exit 1
fi

# 2. Schritte, die abgefragt werden sollen
declare -A STEPS=(
    ["Portainer Installation"]="/etc/scripts/portainer_install.sh"
    ["Portainer Agent Installation (Nur nötig um diese Instanz über eine andere zu Steuern)"]="/etc/scripts/portainer_agent_install.sh"
    ["IPVLAN festlegen"]="/etc/scripts/ipvlan.sh"
    ["Cronjob für Updates erstellen"]="/etc/scripts/cron_job_update_proxmox.sh"
    ["Updates installieren"]="/etc/scripts/ubuntu_update_proxmox.sh"
)

# 3. Schleife: bei jedem Schritt mit whiptail fragen
for desc in "${!STEPS[@]}"; do
    script="${STEPS[$desc]}"

    if whiptail --yesno "Möchten Sie \"$desc\" durchführen?" 8 60; then
        log "$GREEN Starte \"$desc\" (${script})...${RESET}"
        if sudo "$script"; then
            log "$GREEN \"$desc\" erfolgreich abgeschlossen.${RESET}"
        else
            log "$RED Fehler beim Ausführen von \"$desc\".${RESET}"
        fi
    else
        log "$GREEN \"$desc\" übersprungen.${RESET}"
    fi
done

log "$GREEN Setup‑Workflow beendet.${RESET}"