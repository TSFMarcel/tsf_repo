#!/usr/bin/env bash
# ------------------------------------------------------------
# IPvlan‑Netzwerk‑Erstellung für Docker – Whiptail‑Version
# ------------------------------------------------------------
# Farben (nur für Konsole – bei Whiptail nicht nötig)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'        # Keine Farbe

log() { echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1"; }

log "${GREEN}========================================${NC}"
log "${GREEN}IPvlan‑Netzwerk‑Erstellungs‑Skript für Docker gestartet…${NC}"
log "${GREEN}========================================${NC}"

# ------------------------------------------------------------
# Eingaben über Whiptail abfragen
# ------------------------------------------------------------
# Subnetz
SUBNET=$(whiptail --inputbox "Geben Sie das Subnetz (z. B. 192.168.1.0/24) ein:" 10 60 "$SUBNET" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# Gateway
GATEWAY=$(whiptail --inputbox "Geben Sie das Gateway (z. B. 192.168.1.1) ein:" 10 60 "$GATEWAY" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# Parent‑Interface
PARENT_INTERFACE=$(whiptail --inputbox "Parent‑Interface (z. B. eth0, Standard: eth0):" 10 60 "$PARENT_INTERFACE" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
PARENT_INTERFACE=${PARENT_INTERFACE:-eth0}

# IPvlan‑Modus
IPVLAN_MODE=$(whiptail --inputbox "IPvlan‑Modus (l2/l3, Standard: l2):" 10 60 "$IPVLAN_MODE" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1
IPVLAN_MODE=${IPVLAN_MODE:-l2}

# ------------------------------------------------------------
# Erzeugen des Netzwerks
# ------------------------------------------------------------
log "${GREEN}Erstelle IPvlan‑Netzwerk \"ipvlan_network\"…${NC}"
docker network create -d ipvlan \
  --subnet="$SUBNET" \
  --gateway="$GATEWAY" \
  -o parent="$PARENT_INTERFACE" \
  -o ipvlan_mode="$IPVLAN_MODE" \
  --attachable \
  ipvlan_network 2>/dev/null

if [ $? -eq 0 ]; then
  log "${GREEN}Netzwerk erfolgreich erstellt.${NC}"
else
  log "${CYAN}Warnung: Docker‑Netzwerk konnte nicht erstellt werden.${NC}"
fi