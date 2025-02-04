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
echo -e "Der Nginx Proxy Manager wurde gestartet und ist unter \"\033[32mhttp://$(ip a show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1):81\033[0m\" erreichbar."
echo "Die Default Zugangsdaten lauten:"
echo -e "Benutzer: \"\033[32madmin@example.com\033[0m\""
echo -e "Passwort: \"\033[32mchangeme\033[0m\""
