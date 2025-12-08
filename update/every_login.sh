#!/bin/bash

# --- KONFIGURATION ---
SCRIPT_DIR="/etc/scripts/update"
TITLE="⚙️ Server-Automatisierungsmenü"
MENU_TEXT="Wähle eine Aktion aus der Liste:"
# ---------------------

# Funktion zur Ausführung externer Skripte
execute_script() {
    local script_name="$1"
    local script_path="$SCRIPT_DIR/$script_name"
    
    if [ ! -f "$script_path" ]; then
        whiptail --msgbox "FEHLER: Skript $script_path nicht gefunden! Stelle sicher, dass die Datei existiert." 10 70
        return 1
    fi
    
    whiptail --infobox "Starte Skript: $script_name..." 8 60
    sleep 2
    
    # Ausführung des Skripts
    bash "$script_path"
    
    whiptail --msgbox "Skript $script_name beendet. Drücke OK, um zum Menü zurückzukehren." 10 70
}

# Hauptmenü-Schleife
while true; do
    CHOICE=$(whiptail --title "$TITLE" --menu "$MENU_TEXT" 25 85 15 \
    "A.1" "Proxmox - Update von Ubuntu" \
    "A.2" "Proxmox Host - Cronjob für automatische Updates erstellen/aktualisieren" \
    "---" "--------------------------------------------------------" \
    "B.1" "HyperV - Update von Ubuntu" \
    "B.2" "HyperV - Cronjob für automatische Updates erstellen/aktualisieren" \
    "B.3" "HyperV - Feste IP-Adresse festlegen (Netplan)" \
    "---" "--------------------------------------------------------" \
    "C.1" "Nachinstallieren von Portainer (Management-Interface)" \
    "C.2" "Installation des Portainer Agents zur Fernverwaltung" \
    "C.3" "IPVLAN für Docker anlegen (vorerst nur eines möglich)" \
    "C.4" "Netbird Agent installieren und einrichten" \
    "---" "--------------------------------------------------------" \
    "EXIT" "Skript beenden" \
    3>&1 1>&2 2>&3)
    
    if [ $? -ne 0 ] || [ "$CHOICE" == "EXIT" ]; then
        whiptail --msgbox "Skript wird beendet. Tschüss!" 8 45
        exit 0
    fi
    
    # Verarbeite die Auswahl
    case "$CHOICE" in
        "A.1")
            execute_script "ubuntu_update_proxmox.sh"
            ;;
        "A.2")
            execute_script "cron_job_update_proxmox.sh"
            ;;
        "B.1")
            execute_script "ubuntu_update.sh"
            ;;
        "B.2")
            execute_script "cron_job_update.sh"
            ;;
        "B.3")
            execute_script "netplan_ubuntu.sh"
            ;;
        "C.1")
            execute_script "portainer_install.sh"
            ;;
        "C.2")
            execute_script "portainer_agent_install.sh"
            ;;
        "C.3")
            execute_script "ipvlan.sh"
            ;;
        "C.4")
            execute_script "netbird_setup.sh"
            ;;
        "---")
            # Ignoriere Trennlinien
            ;;
        *)
            whiptail --msgbox "Ungültige Auswahl." 8 45
            ;;
    esac
done