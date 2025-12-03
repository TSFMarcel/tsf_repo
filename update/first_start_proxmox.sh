#!/usr/bin/env bash
# ────────────────────────────────────────────────────────────────────────
# First‑Start‑Script für Proxmox VE – interaktive Variante
# ────────────────────────────────────────────────────────────────────────

# -------- Log‑Datei ----------
LOG_FILE="/var/log/setup_all.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }

# -------- Haupt‑Schritte ----------
DESCS=(
    "Portainer Installation"
    "Portainer Agent Installation (nur nötig, um diese Instanz über eine andere zu steuern)"
    "IPVLAN festlegen"
    "Cron‑Job für Updates erstellen"
    "Updates installieren"
)

# -------- zugehörige Skripte ----------
SCRIPTS=(
    "/etc/scripts/update/portainer_install.sh"
    "/etc/scripts/update/portainer_edge_agent_install.sh"
    "/etc/scripts/update/ipvlan.sh"
    "/etc/scripts/update/cron_job_update_proxmox.sh"
    "/etc/scripts/update/ubuntu_update_proxmox.sh"
)

# -------- Abfrage‑Schleife ----------
for idx in "${!DESCS[@]}"; do
    desc="${DESCS[$idx]}"
    script="${SCRIPTS[$idx]}"

    if whiptail --yesno "Möchten Sie \"$desc\" durchführen?" 10 60; then
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