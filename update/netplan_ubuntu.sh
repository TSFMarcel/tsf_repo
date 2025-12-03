#!/usr/bin/env bash
# ───────────────────────────────────────────────────────────────────────────────
# Netplan‑Static‑IP‑Setup‑Script (interaktiv mit Whiptail)
# ───────────────────────────────────────────────────────────────────────────────

# -------------------------------------------------------------
# Konstanten & Pfade
# -------------------------------------------------------------
CONFIG_FILE="/etc/netplan/50-cloud-init.yaml"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
NC="\033[0m"

# -------------------------------------------------------------
# Hilfsfunktionen
# -------------------------------------------------------------
subnet_to_cidr() {
    local subnet=$1
    local cidr=0
    for octet in $(echo "$subnet" | tr '.' ' '); do
        case $octet in
            255) cidr=$((cidr + 8)) ;;
            254) cidr=$((cidr + 7)) ;;
            252) cidr=$((cidr + 6)) ;;
            248) cidr=$((cidr + 5)) ;;
            240) cidr=$((cidr + 4)) ;;
            224) cidr=$((cidr + 3)) ;;
            192) cidr=$((cidr + 2)) ;;
            128) cidr=$((cidr + 1)) ;;
            0)   ;;
            *) echo "Ungültige Subnetzmaske: $subnet" 1>&2; exit 1 ;;
        esac
    done
    echo "$cidr"
}

# -------------------------------------------------------------
# Begrüßung (keine Farben im Whiptail‑Dialog)
# -------------------------------------------------------------
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  Netplan Static IP Configuration Script${NC}"
echo -e "${GREEN}============================================================${NC}"
echo

# -------------------------------------------------------------
# Eingabe der Netplan‑Parameter via Whiptail
# -------------------------------------------------------------
INTERFACE=$(whiptail --inputbox "Geben Sie den Namen des Netzwerkinterfaces ein (z. B. eth0):" 10 60 "" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

STATIC_IP=$(whiptail --inputbox "Geben Sie die statische IP-Adresse ein (z. B. 192.168.1.100):" 10 60 "" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

SUBNET_MASK=$(whiptail --inputbox "Geben Sie die Subnetzmaske ein (z. B. 255.255.255.0):" 10 60 "" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

GATEWAY=$(whiptail --inputbox "Geben Sie die Gateway-Adresse ein (z. B. 192.168.1.1):" 10 60 "" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

DNS_SERVERS=$(whiptail --inputbox "Geben Sie die DNS‑Server ein (kommagetrennt, z. B. 8.8.8.8,8.8.4.4):" 10 60 "" 3>&1 1>&2 2>&3)
[[ $? -ne 0 ]] && exit 0

# -------------------------------------------------------------
# Berechnungen
# -------------------------------------------------------------
CIDR=$(subnet_to_cidr "$SUBNET_MASK")
CIDR_IP="$STATIC_IP/$CIDR"

# -------------------------------------------------------------
# Backup der alten Konfiguration
# -------------------------------------------------------------
BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)"
sudo cp "$CONFIG_FILE" "$BACKUP_FILE"
whiptail --msgbox "Die aktuelle Konfigurationsdatei wurde gesichert unter:\n$BACKUP_FILE" 12 70

# -------------------------------------------------------------
# Neue Konfiguration schreiben
# -------------------------------------------------------------
sudo tee "$CONFIG_FILE" > /dev/null <<EOL
network:
  version: 2
  ethernets:
    $INTERFACE:
      dhcp4: false
      addresses:
        - $CIDR_IP
      routes:
        - to: 0.0.0.0/0
          via: $GATEWAY
      nameservers:
        addresses: [$DNS_SERVERS]
EOL

whiptail --msgbox "Die neue Konfiguration wurde in\n$CONFIG_FILE gespeichert." 12 70

# -------------------------------------------------------------
# Netplan anwenden (ja/nein)
# -------------------------------------------------------------
if whiptail --yesno "Möchten Sie die neue Netplan-Konfiguration jetzt anwenden?" 10 60; then
    sudo netplan apply
    if [[ $? -eq 0 ]]; then
        whiptail --msgbox "Netplan-Konfiguration wurde erfolgreich angewendet." 10 60
    else
        whiptail --msgbox "Fehler beim Anwenden der Netplan-Konfiguration.\nBitte prüfen Sie die Datei: rám $CONFIG_FILE" 12 70
    fi
else
    whiptail --msgbox "Netplan-Konfiguration wurde nicht angewendet.\nSie können später mit 'sudo netplan apply' aktivieren." 12 70
fi