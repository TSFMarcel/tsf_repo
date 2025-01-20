#!/bin/bash

# Fest definierter Pfad zum Skript
script_path="/etc/scripts/ubuntu_update.sh"

# Funktion, um den Cron-Job zu aktualisieren oder hinzuzufügen
update_cronjob() {
    local minute="$1"
    local hour="$2"
    local day="$3"
    local month="$4"
    local weekday="$5"

    # Überprüfen, ob das Skript existiert
    if [[ ! -f "$script_path" ]]; then
        echo "Das angegebene Skript existiert nicht: $script_path"
        exit 1
    fi

    # Cronjob-Format erstellen
    cron_command="$minute $hour $day $month $weekday $script_path"

    # Bestehenden Cron-Job suchen und aktualisieren, wenn vorhanden
    crontab -l | grep -v "$script_path" | { cat; echo "$cron_command"; } | crontab -

    echo "Cron-Job wurde erfolgreich gesetzt oder aktualisiert."
}

# Interaktive Eingabe der Cron-Zeitfelder
echo "Gib den Minutenwert für den Cron-Job an (0-59):"
read -r minute

echo "Gib den Stundenwert für den Cron-Job an (0-23):"
read -r hour

echo "Gib den Tag des Monats für den Cron-Job an (1-31):"
read -r day

echo "Gib den Monat für den Cron-Job an (1-12):"
read -r month

echo "Gib den Wochentag für den Cron-Job an (0-6, 0=Sonntag):"
read -r weekday

# Cron-Job setzen oder aktualisieren
update_cronjob "$minute" "$hour" "$day" "$month" "$weekday"
