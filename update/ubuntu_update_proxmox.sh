#!/bin/bash
# ---------------------------------------------------------------
# Ubuntu Update Skript (Proxmox)
# inkl. NVIDIA-Treiber Update-Exclusion
# ---------------------------------------------------------------

set -euo pipefail

# ------------------------------------------------------------------
# Farben für Ausgabe
# ------------------------------------------------------------------
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# ------------------------------------------------------------------
# Log-Datei
# ------------------------------------------------------------------
LOG_FILE="/var/log/ubuntu_update.log"
touch "$LOG_FILE"

# ------------------------------------------------------------------
# Logging-Funktion
# ------------------------------------------------------------------
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------------
# 1. Prüfe / installiere whiptail
# ------------------------------------------------------------------
install_whiptail() {
    if command -v whiptail &>/dev/null; then
        log_message "${GREEN}whiptail ist bereits installiert.${RESET}"
        return
    fi

    log_message "${GREEN}whiptail nicht gefunden – Installation startet...${RESET}"

    if command -v apt-get &>/dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y whiptail
    else
        log_message "${RED}APT nicht verfügbar – Abbruch.${RESET}"
        exit 1
    fi

    command -v whiptail &>/dev/null || {
        log_message "${RED}whiptail Installation fehlgeschlagen.${RESET}"
        exit 1
    }

    log_message "${GREEN}whiptail erfolgreich installiert.${RESET}"
}

# ------------------------------------------------------------------
# 2. NVIDIA-Treiber von Updates ausschließen
# ------------------------------------------------------------------
exclude_nvidia_updates() {
    log_message "${GREEN}Prüfe installierte NVIDIA-Pakete...${RESET}"

    NVIDIA_PACKAGES=$(dpkg -l | awk '/^ii/ && $2 ~ /^nvidia/ {print $2}')

    if [[ -n "$NVIDIA_PACKAGES" ]]; then
        log_message "${GREEN}NVIDIA-Pakete gefunden:${RESET} $NVIDIA_PACKAGES"
        for pkg in $NVIDIA_PACKAGES; do
            sudo apt-mark hold "$pkg" >> "$LOG_FILE" 2>&1
        done
        log_message "${GREEN}NVIDIA-Pakete wurden von Updates ausgeschlossen.${RESET}"
    else
        log_message "${GREEN}Keine NVIDIA-Pakete installiert.${RESET}"
    fi
}

# ------------------------------------------------------------------
# 3. Systembereinigung
# ------------------------------------------------------------------
system_cleanup() {
    log_message "${GREEN}Führe apt clean aus...${RESET}"
    sudo apt clean >> "$LOG_FILE" 2>&1

    log_message "${GREEN}Führe apt autoremove aus...${RESET}"
    sudo apt autoremove -y >> "$LOG_FILE" 2>&1
}

# ------------------------------------------------------------------
# 4. System Update / Upgrade
# ------------------------------------------------------------------
system_update() {
    log_message "${GREEN}Führe apt update aus...${RESET}"
    sudo apt update >> "$LOG_FILE" 2>&1

    log_message "${GREEN}Führe apt upgrade aus...${RESET}"
    sudo apt upgrade -y >> "$LOG_FILE" 2>&1

    log_message "${GREEN}System-Updates abgeschlossen.${RESET}"
}

# ------------------------------------------------------------------
# 5. Docker & Docker Compose Installation
# ------------------------------------------------------------------
install_docker() {
    log_message "${GREEN}Installiere Docker & Docker Compose...${RESET}"

    systemctl disable hv-kvp-daemon.service &>/dev/null || true

    sudo apt install -y ca-certificates curl gnupg lsb-release >> "$LOG_FILE" 2>&1

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update >> "$LOG_FILE" 2>&1
    sudo apt install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin >> "$LOG_FILE" 2>&1

    log_message "${GREEN}Docker Installation abgeschlossen.${RESET}"
}

# ------------------------------------------------------------------
# 6. Neustart
# ------------------------------------------------------------------
system_reboot() {
    log_message "${GREEN}System wird neu gestartet...${RESET}"
    sudo reboot >> "$LOG_FILE" 2>&1
}

# =========================
# Hauptprogramm
# =========================
log_message "${GREEN}Starte Update-Skript...${RESET}"

install_whiptail
exclude_nvidia_updates
system_cleanup
system_update
install_docker
system_reboot
