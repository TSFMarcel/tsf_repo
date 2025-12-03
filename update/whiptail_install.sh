#!/usr/bin/env bash
# whiptail‑Installer + Testabfrage (Deutsch)

set -e

install_whiptail() {
  # Prüfe, ob ein Paketmanager vorhanden ist und installiere whiptail / dialog
  if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y whiptail
  elif command -v dnf &>/dev/null; then
    dnf install -y util-linux-user
  elif command -v yum &>/dev/null; then
    yum install -y util-linux-user
  elif command -v pacman &>/dev/null; then
    pacman -Sy --noconfirm dialog
  elif command -v apk &>/dev/null; then
    apk add --no-cache dialog
  else
    echo "Kein bekannter Paketmanager gefunden – bitte whiptail oder dialog manuell installieren." >&2
    exit 1
  fi

  # Prüfe erneut, ob whiptail vorhanden ist
  if ! command -v whiptail &>/dev/null; then
    echo "whiptail konnte nicht installiert werden." >&2
    exit 1
  fi
}

# -------- Hauptablauf ----------
if ! command -v whiptail &>/dev/null; then
  echo "whiptail nicht gefunden – Installation wird gestartet..."
  install_whiptail
fi