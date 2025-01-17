#!/bin/bash

# Farben für die Ausgabe
GREEN='\033[0;32m'
NC='\033[0m' # Keine Farbe

echo -e "${GREEN}IPvlan-Netzwerk-Erstellungs-Skript gestartet...${NC}"

# Eingaben des Benutzers abfragen
read -p "Geben Sie das Subnetz (z. B. 192.168.1.0/24): " SUBNET
read -p "Geben Sie das Gateway (z. B. 192.168.1.1): " GATEWAY
read -p "Geben Sie das Parent-Interface an (z. B. eth0): " PARENT_INTERFACE
read -p "Möchten Sie den IPvlan-Modus angeben? (l2/l3, Standard: l2): " IPVLAN_MODE

# Standardmodus festlegen, falls nicht angegeben
IPVLAN_MODE=${IPVLAN_MODE:-l2}

# IPvlan-Netzwerk erstellen
echo -e "${GREEN}IPvlan-Netzwerk wird mit der Option '--attachable' erstellt...${NC}"
docker network create -d ipvlan \
  --subnet="$SUBNET" \
  --gateway="$GATEWAY" \
  -o parent="$PARENT_INTERFACE" \
  -o ipvlan_mode="$IPVLAN_MODE" \
  --attachable \
  ipvlan_net
