  GNU nano 7.2                                                                                    check-unifi.sh
#!/bin/bash

# === KONFIGURATION ===
CONTAINER_NAME="Unifi-Network-Application"    # Name des Containers, der überprüft werden soll
COMPOSE_PATH="/etc/scripts/unifi/docker-compose.yml"  # Pfad zu deiner docker-compose.yml

# === PRÜFEN, OB CONTAINER LÄUFT ===
if docker ps --filter "name=${CONTAINER_NAME}" --filter "status=running" | grep -q ${CONTAINER_NAME}; then
    echo "$(date): ✅ Container '${CONTAINER_NAME}' läuft."
else
    echo "$(date): ⚠️  Container '${CONTAINER_NAME}' läuft nicht – starte neu ..."

    # In das Compose-Verzeichnis wechseln
    cd "$(dirname "$COMPOSE_PATH")" || exit 1

    # Container neu starten
    docker compose down
    docker compose up -d

    if docker ps --filter "name=${CONTAINER_NAME}" --filter "status=running" | grep -q ${CONTAINER_NAME}; then
        echo "$(date): 🚀 Container '${CONTAINER_NAME}' erfolgreich neu gestartet."
    else
        echo "$(date): ❌ Fehler: Container '${CONTAINER_NAME}' konnte nicht gestartet werden!"
    fi
fi
