#!/bin/bash
sudo apt update -y && apt upgrade -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker $USER
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
