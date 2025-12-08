#!/usr/bin/env bash
# ----------------------------------------------------------
# Update‑/Netzwerk‑Tool‑Menu mit Platzhaltern (Gruppierung)
# ----------------------------------------------------------
SCRIPT_DIR="/etc/scripts/update"

# Whiptail muss installiert sein
if ! command -v whiptail >/dev/null 2>&1; then
  echo "Fehler: whiptail ist nicht installiert."
  exit 1
fi

while true; do
  CHOICE=$(whiptail --title "Update‑ und Netzwerk‑Tool‑Menu" \
            --menu "Wähle aus was du tun möchtest:" 24 80 12 \
            "1" "─────────────────────Proxmox Hostsystem──────────────────" \
            "1.1" "Update von Ubuntu" \
            "1.2" "Cronjob für automatische Updates erstellen/aktualisieren" \
            "2" "────────────────────HyperV Hostsystem────────────────────" \
            "2.1" "Update von Ubuntu" \
            "2.2" "Cronjob für automatische Updates erstellen/aktualisieren" \
            "2.3" "Feste IP‑Adresse festlegen (Netplan)" \
            "3" "──────────────────────────Docker──────────────────────────" \
            "3.1" "Nachinstallieren von Portainer (Management‑Interface)" \
            "3.2" "Installation des Portainer Agents zur Fernverwaltung" \
            "3.3" "IPVLAN für Docker anlegen (vorerst nur eines möglich)" \
            "3.4" "Netbird Agent installieren und einrichten" \
            "4" "──────────────────────────────────────────────────────────" \
            "q"   "Beenden" 3>&1 1>&2 2>&3)

  # ESC / X
  if [[ $? -ne 0 ]]; then
    echo "Abbruch."
    exit 1
  fi

  case "$CHOICE" in
    "1.1") bash "$SCRIPT_DIR/ubuntu_update_proxmox.sh" ;;
    "1.2") bash "$SCRIPT_DIR/cron_job_update_proxmox.sh" ;;
    "2.1") bash "$SCRIPT_DIR/ubuntu_update.sh" ;;
    "2.2") bash "$SCRIPT_DIR/cron_job_update.sh" ;;
    "2.3") bash "$SCRIPT_DIR/netplan_ubuntu.sh" ;;
    "3.1") bash "$SCRIPT_DIR/portainer_install.sh" ;;
    "3.2") bash "$SCRIPT_DIR/portainer_agent_install.sh" ;;
    "3.3") bash "$SCRIPT_DIR/ipvlan.sh" ;;
    "3.4") bash "$SCRIPT_DIR/netbird_setup.sh" ;;
    "q")   echo "Programm beendet."; exit 0 ;;
    # Platzhalter‑Zeilen – nichts tun
    "1"|"2"|"3"|"4") ;;
    *)     echo "Ungültige Auswahl." ;;
  esac
done