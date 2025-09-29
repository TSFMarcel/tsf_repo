#!/bin/bash
# update_unifi_containers.sh
# Aktualisiert automatisch alle Container in /etc/scripts/unifi via Docker Compose

COMPOSE_DIR="/etc/scripts/unifi"

# 0️⃣ Prüfen, ob Docker Compose installiert ist
if ! docker compose version &> /dev/null; then
    echo "Docker Compose nicht gefunden! Bitte vorher installieren."
    exit 1
fi

# 1️⃣ Compose-Verzeichnis prüfen
if [ ! -f "$COMPOSE_DIR/docker-compose.yml" ]; then
    echo "docker-compose.yml nicht gefunden in $COMPOSE_DIR"
    exit 1
fi

cd "$COMPOSE_DIR" || exit

# 2️⃣ Alte Images ziehen
echo "Ziehe neueste Images..."
docker compose pull

# 3️⃣ Container neu starten
echo "Starte Container mit neuen Images..."
docker compose up -d

# 4️⃣ Ausgabe aktualisierter Container
echo "Aktuelle Container-Status:"
docker compose ps
