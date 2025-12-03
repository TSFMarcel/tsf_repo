#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# Wrapper‑Skript: Whiptail‑Installation + optionale Ausführung
# (Reihenfolge wird garantiert beibehalten)
# ─────────────────────────────────────────────────────────────────────
# Farben – ausschließlich für die Log‑Ausgabe, nicht im Whiptail‑Fenster
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Log‑Datei
LOG_FILE="/var/log/setup_all.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }

# ─────────────────────────────────────────────────────────────────────
# Reihenfolge der Schritte festlegen
# ─────────────────────────────────────────────────────────────────────
# Beschreibungen in exakt der gewünschten Reihenfolge
DESCS=(
    "Portainer Installation"
    "Portainer Edge Agent Installation (nur nötig, um diese Instanz über eine andere zu steuern)"
    "IPVLAN festlegen"
    "Cron‑Job für Updates erstellen"
    "Netplan‑Konfiguration"
    "Updates installieren"
)

# Entsprechende Skripte – gleiche Indizes wie in DESCS
SCRIPTS=(
    "/etc/scripts/update/portainer_install.sh"
    "/etc/scripts/update/portainer_edge_agent.sh"
    "/etc/scripts/update/ipvlan.sh"
    "/etc/scripts/update/cron_job_update.sh"
    "/etc/scripts/update/netplan_ubuntu.sh"
    "/etc/scripts/update/ubuntu_update.sh"
)

# ─────────────────────────────────────────────────────────────────────
# Abfrage‑Schleife – immer in der definierten Reihenfolge
# ─────────────────────────────────────────────────────────────────────
for idx in "${!DESCS[@]}"; do
    desc="${DESCS[$idx]}"
    script="${SCRIPTS[$idx]}"

    if whiptail --yesno "Möchten Sie \"$desc\" durchführen?" 8 60; then
        log "${GREEN}Starte \"$desc\" (${script})...${RESET}"
        if sudo "$script"; then
            log "${GREEN}\"$desc\" erfolgreich abgeschlossen.${RESET}"
        else
            log "${RED}Fehler beim Ausführen von \"$desc\".${RESET}"
        fi
    else
        log "${GREEN}\"$desc\" übersprungen.${RESET}"
    fi
done

log "${GREEN}Setup‑Workflow beendet.${RESET}"