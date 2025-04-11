#!/bin/bash

set -e

# 🧾 Logisches Volume ermitteln
LV_PATH="/dev/mapper/ubuntu--vg-ubuntu--lv"
PV_PATH="/dev/sda3"

echo "📦 Physisches Volume erweitern..."
sudo pvresize "$PV_PATH"

echo "📏 Logisches Volume erweitern auf 100% freien Platz..."
sudo lvextend -l +100%FREE "$LV_PATH"

echo "🧰 Dateisystem erweitern (ext4)..."
sudo resize2fs "$LV_PATH"

echo "✅ Speichererweiterung abgeschlossen!"
