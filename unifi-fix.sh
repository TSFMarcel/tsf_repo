#!/bin/bash

# Verzeichnisse definieren
UNIFI_DIR="/var/lib/docker/unifi"
MONGO_DIR="/var/lib/docker/mongodb-unifi"

echo "⚠️ ACHTUNG: Dieser Vorgang löscht Daten unwiderruflich. Bitte mache vorher ein Konfigurationsbackup des Unifi Controllers, dieses muss danach wieder eingespielt werden. Fortfahren? (j/n)"
read -r confirm

if [[ "$confirm" != "j" ]]; then
  echo "❌ Abgebrochen."
  exit 1
fi

echo "🧹 Lösche alle Inhalte in $UNIFI_DIR..."
if [ -d "$UNIFI_DIR" ]; then
  rm -rf "$UNIFI_DIR"/*
  echo "✅ $UNIFI_DIR geleert."
else
  echo "⚠️ Verzeichnis $UNIFI_DIR existiert nicht."
fi

echo "🧹 Lösche Inhalte in $MONGO_DIR – außer init-mongo.sh..."
if [ -d "$MONGO_DIR" ]; then
  find "$MONGO_DIR" -mindepth 1 -not -name 'init-mongo.sh' -exec rm -rf {} +
  echo "✅ $MONGO_DIR bereinigt (init-mongo.sh bleibt erhalten)."
else
  echo "⚠️ Verzeichnis $MONGO_DIR existiert nicht."
fi

echo "✅ Alles erledigt!"

