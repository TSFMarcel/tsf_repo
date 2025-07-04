#!/bin/bash

set -e

LV_PATH="/dev/mapper/ubuntu--vg-ubuntu--lv"
PV_PATH="/dev/sda3"
DISK_PATH="/dev/sda"

echo "🔧 Prüfe, ob 'parted' installiert ist..."
if ! command -v parted >/dev/null 2>&1; then
    echo "📦 'parted' fehlt – wird jetzt installiert..."
    sudo apt update
    sudo apt install -y parted
else
    echo "✅ 'parted' ist bereits installiert."
fi

echo "🔍 Vergleiche Partitionsgröße mit Diskgröße..."
disk_size=$(lsblk -bno SIZE "$DISK_PATH")
pv_size=$(lsblk -bno SIZE "$PV_PATH")

if [ "$disk_size" -gt "$pv_size" ]; then
    echo "📐 Vergrößere Partition 3 auf volle Größe..."
    sudo parted "$DISK_PATH" --script resizepart 3 100%
    echo "🔁 Lade neue Partitionstabelle..."
    sudo partprobe
    sleep 2
else
    echo "✅ Partition 3 nutzt bereits den vollen Speicherplatz."
fi

echo "📦 Erweitere physisches Volume..."
sudo pvresize "$PV_PATH"

echo "📏 Erweitere logisches Volume auf 100% des freien Platzes..."
sudo lvextend -l +100%FREE "$LV_PATH"

echo "🧰 Vergrößere ext4-Dateisystem..."
sudo resize2fs "$LV_PATH"

echo "🎉 Speichererweiterung abgeschlossen!"
