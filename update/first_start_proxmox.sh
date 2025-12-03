# ---------------------------------------------------------------------
# Reihenfolge der Schritte festlegen
# ---------------------------------------------------------------------
# Text‑Beschreibungen – Reihenfolge bestimmt die Abfrage‑Reihenfolge
DESCS=(
    "Portainer Installation"
    "Portainer Agent Installation (nur nötig, um diese Instanz über eine andere zu steuern)"
    "IPVLAN festlegen"
    "Cron‑Job für Updates erstellen"
    "Updates installieren"
)

# zugehörige Skripte – gleiche Indizes wie in DESCS
SCRIPTS=(
    "/etc/scripts/portainer_install.sh"
    "/etc/scripts/portainer_agent_install.sh"
    "/etc/scripts/ipvlan.sh"
    "/etc/scripts/cron_job_update_proxmox.sh"
    "/etc/scripts/ubuntu_update_proxmox.sh"
)

# ---------------------------------------------------------------------
# Abfrage‑Schleife – immer in der definierten Reihenfolge
# ---------------------------------------------------------------------
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