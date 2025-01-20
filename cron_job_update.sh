#!/bin/bash
GREEN='\033[0;32m'
echo -e "${GREEN}===============================================${NC}"
echo -e "${GREEN}Cronjob Script für Automatische Ubuntu Updates${NC}"
echo -e "${GREEN}===============================================${NC}"
# Pfad zum zu ausführenden Skript
script_path="/etc/scripts/ubuntu_update.sh"

# Funktion, um den systemweiten Cron-Job zu aktualisieren oder hinzuzufügen
update_system_cronjob() {
    local minute="$1"
    local hour="$2"
    local day="$3"
    local month="$4"
    local weekday="$5"
    local user="root"

    # Überprüfen, ob das Skript existiert
    if [[ ! -f "$script_path" ]]; then
        echo "Das angegebene Skript existiert nicht: $script_path"
        exit 1
    fi

    # Cronjob-Format: <Minute> <Stunde> <Tag> <Monat> <Wochentag> <Benutzer> <Befehl>
    cron_command="$minute $hour $day $month $weekday $user $script_path"

    # Prüfen, ob der Eintrag bereits in /etc/crontab existiert
    if grep -Fq "$script_path" /etc/crontab; then
        # Bestehenden Eintrag ersetzen
        sudo sed -i "\|$script_path|c\\$cron_command" /etc/crontab
        echo "Systemweiter Cron-Job aktualisiert: $cron_command"
    else
        # Neuen Eintrag hinzufügen
        echo "$cron_command" | sudo tee -a /etc/crontab > /dev/null
        echo "Systemweiter Cron-Job hinzugefügt: $cron_command"
    fi

    # Neustart des Cron-Dienstes, um Änderungen anzuwenden
    sudo service cron restart
}

# Interaktive Eingabe der Cron-Zeitfelder
echo "Gib den Minutenwert für den Cron-Job an (0-59) oder (*) für jede Minute:"
read -r minute

echo "Gib den Stundenwert für den Cron-Job an (0-23) oder (*) für jede Stunde:"
read -r hour

echo "Gib den Tag des Monats für den Cron-Job an (1-31) oder (*) für jeden Tag:"
read -r day

echo "Gib den Monat für den Cron-Job an (1-12) oder (*) für jeden Monat:"
read -r month

echo "Gib den Wochentag für den Cron-Job an (0-6, 0=Sonntag) oder (*) für jeden Wochentag:"
read -r weekday

# Cron-Job setzen oder aktualisieren
update_system_cronjob "$minute" "$hour" "$day" "$month" "$weekday"
