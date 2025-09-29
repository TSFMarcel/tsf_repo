#!/bin/bash
# Farben für die Ausgabe
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# convert_unifi_mongo_dynamic_install.sh
# Installiert Docker falls nötig, liest MongoDB IP + Env aus und erstellt docker-compose.yml für Mongo + Unifi

# Container-Namen
MONGO_CONTAINER="mongoDB-Unifi"
UNIFI_CONTAINER="Unifi-Network-Application"

# 0️⃣ Docker installieren falls nicht vorhanden
if ! command -v docker &> /dev/null; then
    echo "Docker nicht gefunden, wird installiert..."
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# 1️⃣ Prüfen ob Docker läuft
if ! docker info &> /dev/null; then
    echo "Docker läuft nicht! Bitte sicherstellen, dass der Docker-Dienst aktiv ist."
    exit 1
fi

# 2️⃣ MongoDB IP auslesen
MONGO_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$MONGO_CONTAINER")
if [ -z "$MONGO_IP" ]; then
    echo "Fehler: konnte IP von $MONGO_CONTAINER nicht auslesen!"
    exit 1
fi
echo "MongoDB IP: $MONGO_IP"

# 3️⃣ MongoDB Umgebungsvariablen auslesen
get_env() {
    docker exec "$MONGO_CONTAINER" printenv "$1"
}

MONGO_INITDB_ROOT_USERNAME=$(get_env MONGO_INITDB_ROOT_USERNAME)
MONGO_INITDB_ROOT_PASSWORD=$(get_env MONGO_INITDB_ROOT_PASSWORD)
MONGO_USER=$(get_env MONGO_USER)
MONGO_PASS=$(get_env MONGO_PASS)
MONGO_DBNAME=$(get_env MONGO_DBNAME)
MONGO_AUTHSOURCE=$(get_env MONGO_AUTHSOURCE)

# 4️⃣ Basisordner für Compose-Datei
BASE_DIR="/etc/scripts/unifi"
sudo mkdir -p "$BASE_DIR"

# 5️⃣ Compose-Datei schreiben mit restart: always
cat > "$BASE_DIR/docker-compose.yml" <<EOF
version: '3.9'

services:
  mongodb:
    image: mongo:7.0
    container_name: $MONGO_CONTAINER
    labels:
      - "com.centurylinklabs.watchtower.enable=false"
    restart: always
    networks:
      ipvlan_net:
        ipv4_address: $MONGO_IP
    environment:
      MONGO_INITDB_ROOT_USERNAME: $MONGO_INITDB_ROOT_USERNAME
      MONGO_INITDB_ROOT_PASSWORD: $MONGO_INITDB_ROOT_PASSWORD
      MONGO_USER: $MONGO_USER
      MONGO_PASS: $MONGO_PASS
      MONGO_DBNAME: $MONGO_DBNAME
      MONGO_AUTHSOURCE: $MONGO_AUTHSOURCE
      TZ: Europe/Berlin
    volumes:
      - /var/lib/docker/mongodb-unifi/data:/data/db
      - /var/lib/docker/mongodb-unifi/config:/data/configdb
      - /var/lib/docker/mongodb-unifi/init-mongo.sh:/docker-entrypoint-initdb.d/init-mongo.sh

  unifi:
    image: linuxserver/unifi-network-application:latest
    container_name: $UNIFI_CONTAINER
    labels:
      - "com.centurylinklabs.watchtower.enable=false"
    restart: always
    network_mode: "container:$MONGO_CONTAINER"
    environment:
      PUID: 1000
      PGID: 1000
      TZ: Europe/Berlin
      MONGO_USER: $MONGO_USER
      MONGO_PASS: $MONGO_PASS
      MONGO_HOST: $MONGO_IP
      MONGO_PORT: 27017
      MONGO_DBNAME: $MONGO_DBNAME
      MONGO_AUTHSOURCE: $MONGO_AUTHSOURCE
    volumes:
      - /var/lib/docker/unifi:/config

networks:
  ipvlan_net:
    external: true
EOF

echo "docker-compose.yml wurde erstellt in $BASE_DIR"

# 6️⃣ Alte Container stoppen und löschen
for c in "$MONGO_CONTAINER" "$UNIFI_CONTAINER"; do
    if [ "$(docker ps -q -f name=^${c}$)" ]; then
        echo "Stopping $c..."
        docker stop "$c"
    fi
    if [ "$(docker ps -aq -f name=^${c}$)" ]; then
        echo "Removing $c..."
        docker rm "$c"
    fi
done

# 7️⃣ Compose starten
cd "$BASE_DIR" || exit
docker compose up -d
echo "Container wurden mit docker-compose neu gestartet."

# === Abfrage Cronjob für automatische Updates ===
CRON_SCRIPT="/etc/scripts/unifi_compose_update.sh"

echo -e "\n${GREEN}Möchten Sie automatische Updates per Cronjob einrichten? (j/n)${RESET}"
read -r cron_choice

if [[ "$cron_choice" =~ ^[Jj]$ ]]; then
    echo "Bitte geben Sie die Minute (0-59) ein:"
    read -r cron_minute

    echo "Bitte geben Sie die Stunde (0-23) ein:"
    read -r cron_hour

    echo "Bitte geben Sie den Tag des Monats (1-31 oder * für jeden) ein:"
    read -r cron_day

    echo "Bitte geben Sie den Monat (1-12 oder * für jeden) ein:"
    read -r cron_month

    echo "Bitte geben Sie den Wochentag (0-6, 0=Sonntag, oder * für jeden) ein:"
    read -r cron_weekday

    CRON_ENTRY="$cron_minute $cron_hour $cron_day $cron_month $cron_weekday $CRON_SCRIPT >> /var/log/unifi_compose_update.log 2>&1"

    # Cronjob hinzufügen (nur, wenn nicht bereits vorhanden)
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

    echo "${GREEN}Cronjob erfolgreich eingerichtet:${RESET} $CRON_ENTRY"
else
    echo "${RED}Es wird kein Cronjob für automatische Updates eingerichtet.${RESET}"
fi
