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
