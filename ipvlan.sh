#!/bin/bash

# Farben für die Ausgabe
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # Keine Farbe
echo -e "${GREEN}===============================================${NC}"
echo -e "${GREEN}IPvlan-Netzwerk-Erstellungs-Skript für Docker gestartet...${NC}"
echo -e "${GREEN}===============================================${NC}"
# Eingaben des Benutzers abfragen
read -p "$(echo -e "${CYAN}Geben Sie das Subnetz (z. B. 192.168.1.0/24): ${NC}")" SUBNET
read -p "$(echo -e "${CYAN}Geben Sie das Gateway (z. B. 192.168.1.1): ${NC}")" GATEWAY
read -p "Geben Sie das Parent-Interface an (z.B eth0, Standard/TSF eth0): " PARENT_INTERFACE
read -p "Möchten Sie den IPvlan-Modus angeben? (l2/l3, Standard/TSF: l2): " IPVLAN_MODE

# Standardmodus festlegen, falls nicht angegeben
IPVLAN_MODE=${IPVLAN_MODE:-l2}
PARENT_INTERFACE=${PARENT_INTERFACE:-eth0}

# IPvlan-Netzwerk erstellen
echo -e "${GREEN}IPvlan-Netzwerk wird mit der Option '--attachable' erstellt...${NC}"
docker network create -d ipvlan \
  --subnet="$SUBNET" \
  --gateway="$GATEWAY" \
  -o parent="$PARENT_INTERFACE" \
  -o ipvlan_mode="$IPVLAN_MODE" \
  --attachable \
  ipvlan_net
