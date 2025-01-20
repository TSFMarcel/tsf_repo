#!/bin/bash

# Fest definierter Pfad zum Skript
script_path="/etc/scripts/update_ubuntu.sh"

# Funktion, um den Cron-Job zu aktualisieren oder hinzuzufügen
update_cronjob() {
    local schedule="$1"

    # Überprüfen, ob das Skript existiert
    if [[ ! -f "$script_path" ]]; then
        echo "Das angegebene Skript existiert nicht: $script_path"
        exit 1
    fi

    # Cronjob-Format erstellen
    cron_command="$schedule $script_path"

    # Bestehenden Cron-Job suchen und aktualisieren, wenn vorhanden
    crontab -l | grep -v "$script_path" | { cat; echo "$cron_command"; } | crontab -

    echo "Cron-Job wurde erfolgreich gesetzt oder aktualisiert."
}

# Interaktive Eingabe des Zeitplans
echo "Gib den Zeitplan für den Cron-Job ein (im Format: 'Minuten Stunde Tag Monat Wochentag'):"
read -r schedule

# Cron-Job setzen oder aktualisieren
update_cronjob "$schedule"
