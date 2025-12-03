#!/usr/bin/env bash

# Farben für die Whiptail-Nachrichten
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Log‑Datei
LOG_FILE="/var/log/setup_all.log"
mkdir -p "$(dirname "$LOG_FILE")"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }

# Whiptail-Abfrage für EDGE_ID
EDGE_ID=$(whiptail --inputbox "Bitte geben Sie den Wert für EDGE_ID ein:" 8 78 --title "Eingabe für EDGE_ID" 3>&1 1>&2 2>&3)
if [ $? -eq 0 ]; then
    log "${GREEN}EDGE_ID wurde erfolgreich eingegeben: $EDGE_ID${RESET}"
else
    log "${RED}Die Eingabe für EDGE_ID wurde abgebrochen.${RESET}"
    exit 1
fi

# Whiptail-Abfrage für EDGE_KEY
EDGE_KEY=$(whiptail --inputbox "Bitte geben Sie den Wert für EDGE_KEY ein:" 8 78 --title "Eingabe für EDGE_KEY" 3>&1 1>&2 2>&3)
if [ $? -eq 0 ]; then
    log "${GREEN}EDGE_KEY wurde erfolgreich eingegeben: $EDGE_KEY${RESET}"
else
    log "${RED}Die Eingabe für EDGE_KEY wurde abgebrochen.${RESET}"
    exit 1
fi

# Docker-Run Befehl mit den eingegebenen Werten
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -e EDGE=1 \
  -e EDGE_ID=$EDGE_ID \
  -e EDGE_KEY=$EDGE_KEY \
  -e EDGE_INSECURE_POLL=1 \
  --name portainer_edge_agent \
  portainer/agent:edge