#!/bin/bash

CONFIG_FILE="/etc/netplan/50-cloud-init.yaml"

# Begrüßung
echo "Netplan Static IP Configuration Script"
echo "====================================="

# Benutzereingaben sammeln
read -p "Geben Sie den Namen des Netzwerkinterfaces ein (z. B. eth0): " INTERFACE
read -p "Geben Sie die statische IP-Adresse ein (z. B. 192.168.1.100): " STATIC_IP
read -p "Geben Sie die Subnetzmaske ein (z. B. 255.255.255.0): " SUBNET_MASK
read -p "Geben Sie die Gateway-Adresse ein (z. B. 192.168.1.1): " GATEWAY
read -p "Geben Sie die DNS-Server ein (kommagetrennt, z. B. 8.8.8.8,8.8.4.4): " DNS_SERVERS

# Subnetzmaske in CIDR-Notation umwandeln
IFS='.' read -r -a OCTETS <<< "$SUBNET_MASK"
CIDR=0
for OCTET in "${OCTETS[@]}"; do
  CIDR=$((CIDR+$(echo "obase=2; $OCTET" | bc | grep -o 1 | wc -l)))
done
CIDR_IP="$STATIC_IP/$CIDR"

# Alte Konfigurationsdatei sichern
BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)"
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "Die aktuelle Konfigurationsdatei wurde gesichert unter: $BACKUP_FILE"

# Neue Konfiguration schreiben
cat > "$CONFIG_FILE" <<EOL
network:
  version: 2
  ethernets:
    $INTERFACE:
      dhcp4: false
      addresses:
        - $CIDR_IP
      gateway4: $GATEWAY
      nameservers:
        addresses: [$DNS_SERVERS]
EOL

echo "Die neue Konfiguration wurde in $CONFIG_FILE gespeichert."

# Netplan-Konfiguration anwenden
read -p "Möchten Sie die neue Netplan-Konfiguration jetzt anwenden? (ja/nein): " APPLY
if [[ "$APPLY" =~ ^(ja|yes)$ ]]; then
  netplan apply
  if [[ $? -eq 0 ]]; then
    echo "Die Netplan-Konfiguration wurde erfolgreich angewendet."
  else
    echo "Fehler beim Anwenden der Netplan-Konfiguration. Bitte prüfen Sie die Datei: $CONFIG_FILE"
  fi
else
  echo "Netplan-Konfiguration wurde nicht angewendet. Sie können dies später mit 'sudo netplan apply' tun."
fi
