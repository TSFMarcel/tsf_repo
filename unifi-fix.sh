#!/bin/bash

# Container-Namen
UNIFI_CONTAINER="Unifi-Network-Application"
MONGO_CONTAINER="mongoDB-Unifi"

# Verzeichnisse definieren
UNIFI_DIR="/var/lib/docker/unifi"
MONGO_DIR="/var/lib/docker/mongodb-unifi"

echo "⚠️ ACHTUNG: Dieser Vorgang stoppt Container und löscht Daten unwiderruflich. Bitte mache vorher ein Konfigurationsbackup des Unifi Controllers, dieses muss danach wieder eingespielt werden. Fortfahren? (j/n)"
read -r confirm

if [[ "$confirm" != "j" ]]; then
  echo "❌ Abgebrochen."
  exit 1
fi

# Container stoppen
echo "⏹️ Stoppe Docker-Container..."
docker stop "$UNIFI_CONTAINER" "$MONGO_CONTAINER"

# Löschen von /var/lib/docker/unifi
echo "🧹 Lösche alle Inhalte in $UNIFI_DIR..."
if [ -d "$UNIFI_DIR" ]; then
  rm -rf "$UNIFI_DIR"/*
  echo "✅ $UNIFI_DIR geleert."
else
  echo "⚠️ Verzeichnis $UNIFI_DIR existiert nicht."
fi

# Löschen in /var/lib/docker/mongodb-unifi außer init-mongo.sh
echo "🧹 Lösche Inhalte in $MONGO_DIR – außer init-mongo.sh..."
if [ -d "$MONGO_DIR" ]; then
  find "$MONGO_DIR" -mindepth 1 -not -name 'init-mongo.sh' -exec rm -rf {} +
  echo "✅ $MONGO_DIR bereinigt (init-mongo.sh bleibt erhalten)."
else
  echo "⚠️ Verzeichnis $MONGO_DIR existiert nicht."
fi

# Container starten
echo "▶️ Starte MongoDB-Container ($MONGO_CONTAINER)..."
docker start "$MONGO_CONTAINER"

# Wartezeit
echo "⏳ Warte 60 Sekunden, damit MongoDB vollständig starten kann..."
sleep 60

echo "▶️ Starte UniFi-Controller-Container ($UNIFI_CONTAINER)..."
docker start "$UNIFI_CONTAINER"

echo "✅ Alles erledigt! Beide Container laufen wieder."
