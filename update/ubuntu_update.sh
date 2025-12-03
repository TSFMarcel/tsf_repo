#!/bin/bash
# ---------------------------------------------------------------
#  Ubuntu‑Update‑Skript (HyperV)
# ---------------------------------------------------------------

# Farben für die Ausgabe
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Log‑Datei definieren
LOG_FILE="/var/log/ubuntu_update.log"

# ------------------------------------------------------------------
# Funktion zum Loggen von Nachrichten
# ------------------------------------------------------------------
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------------
# 1. Prüfe/Installiere whiptail (falls noch nicht vorhanden)
# ------------------------------------------------------------------
install_whiptail() {
    if command -v whiptail &>/dev/null; then
        log_message "${GREEN}whiptail ist bereits installiert.${RESET}"
        return
    fi

    log_message "${GREEN}whiptail nicht gefunden – Installation wird gestartet...${RESET}"

    # Für die gängigsten Paketmanager
    if command -v apt-get &>/dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y whiptail
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y util-linux-user
    elif command -v yum &>/dev/null; then
        sudo yum install -y util-linux-user
    elif command -v pacman &>/dev/null; then
        sudo pacman -Sy --noconfirm dialog
    elif command -v apk &>/dev/null; then
        sudo apk add --no-cache dialog
    else
        log_message "${RED}Kein bekannter Paketmanager – bitte whiptail oder dialog manuell installieren.${RESET}"
        exit 1
    fi

    if ! command -v whiptail &>/dev/null; then
        log_message "${RED}whiptail konnte nicht installiert werden.${RESET}"
        exit 1
    fi

    log_message "${GREEN}whiptail erfolgreich installiert.${RESET}"
}

# ------------------------------------------------------------------
# 2. Whiptail installieren (falls nötig)
# ------------------------------------------------------------------
install_whiptail

# ------------------------------------------------------------------
# 3. Loggen des Beginns des Skriptlaufs
# ------------------------------------------------------------------
log_message "${GREEN}Starte das Update-Skript...${RESET}"

# ------------------------------------------------------------------
# 4. System bereinigen
# ------------------------------------------------------------------
log_message "${GREEN}Führe apt clean aus...${RESET}"
if sudo apt clean -y >> "$LOG_FILE" 2>&1; then
    log_message "${GREEN}apt clean abgeschlossen.${RESET}"
else
    log_message "${RED}Fehler bei apt clean.${RESET}"
    exit 1
fi

log_message "${GREEN}Führe apt autoremove aus...${RESET}"
if sudo apt autoremove -y >> "$LOG_FILE" 2>&1; then
    log_message "${GREEN}apt autoremove abgeschlossen.${RESET}"
else
    log_message "${RED}Fehler bei apt autoremove.${RESET}"
    exit 1
fi

# ------------------------------------------------------------------
# 5. Update und Upgrade mit erzwungenen Antworten
# ------------------------------------------------------------------
log_message "${GREEN}Führe apt update aus...${RESET}"
if sudo apt update -y >> "$LOG_FILE" 2>&1; then
    log_message "${GREEN}apt update abgeschlossen.${RESET}"
else
    log_message "${RED}Fehler bei apt update.${RESET}"
    exit 1
fi

log_message "${GREEN}Führe apt upgrade aus...${RESET}"
if sudo apt upgrade -y >> "$LOG_FILE" 2>&1; then
    log_message "${GREEN}apt upgrade abgeschlossen.${RESET}"
else
    log_message "${RED}Fehler bei apt upgrade.${RESET}"
    exit 1
fi

# ------------------------------------------------------------------
# 6. Prüfen, ob linux-azure bereits installiert ist
# ------------------------------------------------------------------
if dpkg -l | grep -q "linux-azure"; then
    log_message "${GREEN}linux-azure ist bereits installiert. Überspringe Installation.${RESET}"
else
    log_message "${GREEN}Installiere linux-azure...${RESET}"
    if sudo apt-get install -y linux-azure >> "$LOG_FILE" 2>&1; then
        log_message "${GREEN}linux-azure erfolgreich installiert.${RESET}"
    else
        log_message "${RED}Fehler bei der Installation von linux-azure.${RESET}"
        exit 1
    fi
fi

log_message "${GREEN}Updates erfolgreich abgeschlossen.${RESET}"

# ------------------------------------------------------------------
# 7. Docker & Docker‑Compose installieren
# ------------------------------------------------------------------
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ------------------------------------------------------------------
# 8. Optional: Neustart des Systems
# ------------------------------------------------------------------
log_message "${GREEN}Starte das System neu...${RESET}"
if sudo reboot >> "$LOG_FILE" 2>&1; then
    log_message "${GREEN}System wird neu gestartet.${RESET}"
else
    log_message "${RED}Fehler beim Neustarten des Systems.${RESET}"
    exit 1
fi