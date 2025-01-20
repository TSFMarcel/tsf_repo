#!/bin/bash

# Fest definierter Pfad zum Skript
script_path="/etc/scripts/update_ubuntu.sh"

# Funktion, um den Cron-Job hinzuzufügen
add_cronjob() {
    local schedule="$1"

    # Überprüfen, ob das Skript existiert
    if [[ ! -f "$script_path" ]]; then
        echo "Das angegebene Skript existiert nicht: $script_path"
        exit 1
    fi

    # Cronjob-Format erstellen
    cron_command="$schedule $script_path"

    # Überprüfen, ob der Cron-Job bereits existiert
    if crontab -l | grep -F "$script_path" > /dev/null; then
        echo "Der Cron-Job für $script_path existiert bereits."
    else
        # Cronjob hinzufügen
        (crontab -l; echo "$cron_command") | crontab -
        echo "Cron-Job wurde erfolgreich hinzugefügt."
    fi
}

# Interaktive Eingabe des Zeitplans
echo "Gib den Zeitplan für den Cron-Job ein (im Format: 'Minuten Stunde Tag Monat Wochentag'):"
read -r schedule

# Cron-Job hinzufügen
add_cronjob "$schedule"
