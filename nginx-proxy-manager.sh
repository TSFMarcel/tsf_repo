#!/bin/bash

docker run -d \
  --name Nginx-Proxy-Manager \
  --restart unless-stopped \
  -p 80:80 \
  -p 81:81 \
  -p 443:443 \
  -v "/var/lib/docker/volumes/npm/data:/data" \
  -v "/var/lib/docker/volumes/npm/letsencrypt:/etc/letsencrypt" \
  docker.io/jc21/nginx-proxy-manager:latest
echo Der Nginx Proxy Manager wurde gestartet und ist unter http://$(ip a show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1):81 erreichbar.
echo Die Zugangsdaten lauten:
echo Benutzer: "admin@example.com"
echo Passwort: "changeme"
