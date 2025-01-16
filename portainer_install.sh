#!/bin/bash
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker $USER
docker pull portainer/portainer-ce:latest
docker run -d -p 9000:9000 --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce:latest
