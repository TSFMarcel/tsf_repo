sudo mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]
Environment=DOCKER_MIN_API_VERSION=1.24" | sudo tee /etc/systemd/system/docker.service.d/override.conf > /dev/null
sudo systemctl daemon-reload
sudo systemctl restart docker
