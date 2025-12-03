#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────
# Cron‑Job‑Setup‑Script (Ubuntu Updates) – Whiptail‑Variante
# ─────────────────────────────────────────────────────────────────────────

# ------------------- Farben (nur für die initiale Ausgabe) ---------------
GREEN="\033[0;32m"
NC="\033[0m"

echo -e "${GREEN}=================================================${NC}"
echo -e "${GREEN}Cronjob‑Setup für Automatische Ubuntu Updates${NC}"
echo -e "${GREEN}=================================================${NC}"
echo

# ------------------- Pfad zum Update‑Skript ------------------------------
SCRIPT_PATH="/etc/scripts/update/ubuntu_update.sh"

# ------------------- Log‑Funktion (optional) -----------------------------
LOG_FILE="/var/log/cron_setup.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') – $1" | tee -a "$LOG_FILE"; }

# ------------------- Cron‑Job‑Austausch/Einfügung -----------------------
update_system_cronjob() {
    local minute="$1" hour="$2" day="$3" month="$4" weekday="$5"
    local user="root"

    # Prüfen, ob das Skript existiert
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        log "❌ Das Skript $SCRIPT_PATH existiert nicht."
        exit 1
    fi

    # Cron‑Format: <M> <H> <T> <M> <W> <Benutzer> <Befehl>
    local cron_cmd="$minute $hour $day $month $weekday $user $SCRIPT_PATH"

    # Ist der Eintrag schon vorhanden?
    if grep -Fq "$SCRIPT_PATH" /etc/crontab; then
        sudo sed -i "\|$SCRIPT_PATH|c\\$cron_cmd" /etc/crontab
        log "✅ Systemweiter Cron‑Job aktualisiert: $cron_cmd"
    else
        echo "$cron_cmd" | sudo tee -a /etc/crontab > /dev/null
        log "✅ Systemweiter Cron‑Job hinzugefügt: $cron_cmd"
    fi

    # Änderungen aktivieren
    sudo service cron restart
    log "🔄 Cron‑Dienst neu gestartet."
}

# ------------------- Whiptail‑Abfragen -------------------------------
minute=$(whiptail --inputbox "Minutenwert (0‑59 oder '*'):" 10 60 "*" 3>&1 1>&2 2>&3)
if [[ $? -ne 0 ]]; then exit 0; fi

hour=$(whiptail --inputbox "Stundenwert (0‑23 oder '*'):" 10 60 "*" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

day=$(whiptail --inputbox "Tag des Monats (1‑31 oder '*'):" 10 60 "*" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

month=$(whiptail --inputbox "Monat (1‑12 oder '*'):" 10 60 "*" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

weekday=$(whiptail --inputbox "Wochentag (0‑6, 0=Sonntag oder '*'):" 10 60 "*" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

# ------------------- Bestätigung -------------------------
if ! whiptail --yesno "Cron‑Job setzen mit folgenden Werten?\n\n$minute $hour $day $month $weekday root $SCRIPT_PATH" 12 70; then
    log "❌ Vorgang abgebrochen."
    exit 0
fi

# ------------------- Job setzen/aktualisieren -------------------------
update_system_cronjob "$minute" "$hour" "$day" "$month" "$weekday"

log "✅ Cron‑Job‑Setup abgeschlossen."