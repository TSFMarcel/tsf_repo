#!/usr/bin/env bash
# ------------------------------------------------------------------
# Netplan Static‑IP‑Konfiguration – Whiptail‑Version
# ------------------------------------------------------------------
# Farben für die reine Konsolenausgabe (keine Wirkung in Whiptail)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'        # Keine Farbe

CONFIG_FILE="/etc/netplan/50-cloud-init.yaml"

log() { echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1"; }

log "${GREEN}==============================${NC}"
log "${GREEN}Netplan Static IP Configuration Script${NC}"
log "${GREEN}==============================${NC}"

# --------------------- Whiptail Eingaben ---------------------------
# 1. Interface‑Name
INTERFACE=$(whiptail --inputbox "Geben Sie den Namen des Netzwerkinterfaces ein (z. B. eth0):" 10 60 "$INTERFACE" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# 2. Statische IP
STATIC_IP=$(whiptail --inputbox "Geben Sie die statische IP-Adresse ein (z. B. 192.168.1.100):" 10 60 "$STATIC_IP" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# 3. Subnetzmaske
SUBNET_MASK=$(whiptail --inputbox "Geben Sie die Subnetzmaske ein (z. B. 255.255.255.0):" 10 60 "$SUBNET_MASK" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# 4. Gateway
GATEWAY=$(whiptail --inputbox "Geben Sie die Gateway-Adresse ein (z. B. 192.168.1.1):" 10 60 "$GATEWAY" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# 5. DNS‑Server (kommagetrennt)
DNS_SERVERS=$(whiptail --inputbox "Geben Sie die DNS‑Server ein (kommagetrennt, z. B. 8.8.8.8,8.8.4.4):" 10 60 "$DNS_SERVERS" 3>&1 1>&2 2>&3)
[ $? -ne 0 ] && exit 1

# --------------------- CIDR‑Umrechnung ---------------------------
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
      *) echo "Ungültige Subnetzmaske: $subnet" >&2; exit 1 ;;
    esac
  done
  echo "$cidr"
}
CIDR=$(subnet_to_cidr "$SUBNET_MASK")
CIDR_IP="${STATIC_IP}/${CIDR}"

# --------------------- Backup & Schreiben ------------------------
BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%Y%m%d%H%M%S)"
log "Backup der aktuellen Konfiguration: $BACKUP_FILE"
cp "$CONFIG_FILE" "$BACKUP_FILE"

cat > "$CONFIG_FILE" <<EOL
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

log "${GREEN}Neue Konfiguration in $CONFIG_FILE gespeichert.${NC}"