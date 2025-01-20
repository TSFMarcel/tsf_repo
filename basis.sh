#!/bin/bash

# Farben für die Ausgabe
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Basis-Skriptordner
SCRIPT_FOLDER="/etc/scripts"
declare -A SCRIPTS=(
    ["ubuntu_update.sh"]="https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/update_ubuntu.sh"
    ["ipvlan.sh"]="https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/ipvlan.sh"
    ["netplan.sh"]="https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/netplan.sh"
    ["ersatz.sh"]="https://raw.githubusercontent.com/TSFMarcel/tsf_repo/refs/heads/main/ersatz.sh"
)

# Funktion: Cron-Zeit abfragen
function ask_cron_time() {
    echo "Bitte geben Sie die Cron-Zeitparameter an:"
    read -p "Minute (0-59): " MINUTE
    read -p "Stunde (0-23): " HOUR
    read -p "Tag des Monats (1-31, * für jeden Tag): " DAY
    read -p "Monat (1-12, * für jeden Monat): " MONTH
    read -p "Wochentag (0-7, wobei 0 und 7 für Sonntag stehen, * für jeden Tag): " WEEKDAY
}

# System bereinigen
echo -e "${GREEN}Führe apt clean aus, um den lokalen Paket-Cache zu bereinigen...${RESET}"
sudo apt clean -y

echo -e "${GREEN}Führe apt autoremove aus, um nicht mehr benötigte Pakete zu entfernen...${RESET}"
sudo apt autoremove -y

# Prüfen, ob cron installiert ist
echo -e "${GREEN}Prüfe, ob cron installiert ist...${RESET}"
if ! dpkg -l | grep -q "^ii.*cron"; then
    echo -e "${RED}cron ist nicht installiert. Installiere cron...${RESET}"
    sudo apt update
    sudo apt install -y cron
    echo -e "${GREEN}cron wurde erfolgreich installiert.${RESET}"
else
    echo -e "${GREEN}cron ist bereits installiert.${RESET}"
fi

# Sicherstellen, dass cron läuft
echo -e "${GREEN}Stelle sicher, dass der cron-Dienst läuft...${RESET}"
sudo systemctl start cron
sudo systemctl enable cron
echo -e "${GREEN}cron-Dienst ist gestartet und aktiviert.${RESET}"

# Skripte-Ordner erstellen
if [ ! -d "$SCRIPT_FOLDER" ]; then
    echo -e "${GREEN}Erstelle Skript-Ordner: $SCRIPT_FOLDER${RESET}"
    sudo mkdir -p "$SCRIPT_FOLDER"
fi

# Skripte herunterladen und Cronjobs hinzufügen
for script in "${!SCRIPTS[@]}"; do
    SCRIPT_PATH="$SCRIPT_FOLDER/$script"
    GITHUB_URL="${SCRIPTS[$script]}"

    echo -e "${GREEN}Herunterladen des Skripts $script von GitHub...${RESET}"
    if wget -O "$SCRIPT_PATH" "$GITHUB_URL"; then
        echo -e "${GREEN}Skript $script erfolgreich heruntergeladen nach $SCRIPT_PATH${RESET}"
    else
        echo -e "${RED}Fehler beim Herunterladen des Skripts $script!${RESET}"
        continue
    fi

    # Skript ausführbar machen
    echo -e "${GREEN}Setze Berechtigungen für $script...${RESET}"
    chmod +x "$SCRIPT_PATH"
    echo -e "${GREEN}Skript $script ist ausführbar.${RESET}"

    # Überprüfen, ob ein Cronjob bereits existiert
    EXISTING_CRONTAB=$(crontab -l 2>/dev/null | grep "$SCRIPT_PATH")
    if [[ -n "$EXISTING_CRONTAB" ]]; then
        echo -e "${GREEN}Ein bestehender Cronjob für $script wurde gefunden:${RESET}"
        echo "$EXISTING_CRONTAB"
        echo -e "${GREEN}Der bestehende Cronjob wird aktualisiert.${RESET}"

        # Bestehenden Cronjob entfernen
        (crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH") | crontab -
    else
        echo -e "${GREEN}Kein bestehender Cronjob für $script gefunden.${RESET}"
    fi

    # Cron-Zeit abfragen
    ask_cron_time

    # Neuen/aktualisierten Cronjob hinzufügen
    CRON_JOB="$MINUTE $HOUR $DAY $MONTH $WEEKDAY $SCRIPT_PATH"
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

    echo -e "${GREEN}Cronjob für $script wurde hinzugefügt oder aktualisiert:${RESET}"
    echo "$CRON_JOB"
done
