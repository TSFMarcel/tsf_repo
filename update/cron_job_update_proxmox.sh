#!/usr/bin/env bash
# ---------------------------------------------
# Cron‑Job‑Setup für automatische Ubuntu‑Updates
# ---------------------------------------------
# Farben für reine Konsolenausgabe (keine Wirkung in Whiptail)
GREEN='\033[0;32m'
NC='\033[0m'  # Keine Farbe

# Begrarton
echo -e "${GREEN}==============================${NC}"
echo -e "${GREEN}Cronjob Script für automatische Ubuntu‑Updates${NC}"
echo -e "${GREEN}==============================${NC}"

# --------------------- Pfad zum Update‑Skript -------------
SCRIPT_PATH="/etc/scripts/update/ubuntu_update_proxmox.sh"

# ---------------------------------------------
# Funktion zum Setzen bzw. Ersetzen des systemweiten
# Cron‑Jobs (/etc/crontab)
# ---------------------------------------------
update_system_cronjob() {
    local minute="$1"
    local hour="$2"
    local day="$3"
    local month="$4"
    local weekday="$5"
    local user="root"

    # Prüfen, ob das Skript existiert
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        echo "Das angegebene Skript existiert nicht: $SCRIPT_PATH"
        exit 1
    fi

    # Cron‑Job‑Format: <Min> <Stunde> <Tag> <Monat> <Wochentag> <Benutzer> <Befehl>
    cron_command="$minute $hour $day $month $weekday $user $SCRIPT_PATH"

    # Existierenden Eintrag in /etc/crontab suchen und ggf. ersetzen
    if grep -Fq "$SCRIPT_PATH" /etc/crontab; then
        sudo sed -i "\|$SCRIPT_PATH|c\\$cron_command" /etc/crontab
        echo "Systemweiter Cron‑Job aktualisiert: $cron_command"
    else
        echo "$cron_command" | sudo tee -a /etc/crontab > /dev/null
        echo "Systemweiter Cron‑Job hinzugefügt: $cron_command"
    fi

    # Änderungen sofort wirksam machen
    sudo service cron restart
}

# ---------------------------------------------
# Whiptail‑basierte Eingabe der Cron‑Zeitfelder
# ---------------------------------------------
# 1. Minute (0‑59 oder '*')
minute=$(whiptail --inputbox "Minutenwert (0‑59 oder '*'):" 10 55 "$minute" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
minute=${minute:-'*'}

# 2. Stunde (0‑23 oder '*')
hour=$(whiptail --inputbox "Stundenwert (0‑23 oder '*'):" 10 55 "$hour" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
hour=${hour:-'*'}

# 3. Tag des Monats (1‑31 oder '*')
day=$(whiptail --inputbox "Tag des Monats (1‑31 oder '*'):" 10 55 "$day" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
day=${day:-'*'}

# 4. Monat (1‑12 oder '*')
month=$(whiptail --inputbox "Monat (1‑12 oder '*'):" 10 55 "$month" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
month=${month:-'*'}

# 5. Wochentag (0‑6, 0=Sonntag oder '*')
weekday=$(whiptail --inputbox "Wochentag (0‑6, 0=Sonntag oder '*'):" 10 55 "$weekday" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
weekday=${weekday:-'*'}

# ---------------------------------------------
# Cron‑Job setzen bzw. aktualisieren
# ---------------------------------------------
update_system_cronjob "$minute" "$hour" "$day" "$month" "$weekday"