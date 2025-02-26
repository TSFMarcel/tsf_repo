#!/bin/bash

# Prüfen, ob das Skript mit -y ausgeführt wurde
auto_confirm=false
if [[ "$1" == "-y" ]]; then
  auto_confirm=true
fi

# Interaktive Abfrage, falls nicht automatisch bestätigt
if ! $auto_confirm; then
  read -p "Möchtest du den Nginx Proxy Manager als Docker mit installieren? (j/n) " choice
  case "$choice" in
    j|J ) echo "Installiere und starte den Nginx Proxy Manager..." ;;
    n|N ) echo "Abbruch."; exit 1 ;;
    * ) echo "Ungültige Eingabe. Abbruch."; exit 1 ;;
  esac
fi

# Docker Container starten
docker run -d \
  --name Nginx-Proxy-Manager \
  --restart unless-stopped \
  -p 80:80 \
  -p 81:81 \
  -p 443:443 \
  -v "/var/lib/docker/volumes/npm/data:/data" \
  -v "/var/lib/docker/volumes/npm/letsencrypt:/etc/letsencrypt" \
  docker.io/jc21/nginx-proxy-manager:latest

# Erfolgsnachricht ausgeben
echo -e "Der Nginx Proxy Manager wurde gestartet und ist unter \"\033[32mhttp://$(ip a show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1):81\033[0m\" erreichbar."
echo "Die Default Zugangsdaten lauten:"
echo -e "Benutzer: \"\033[32madmin@example.com\033[0m\""
echo -e "Passwort: \"\033[32mchangeme\033[0m\""
