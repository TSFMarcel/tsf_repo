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

echo "🔧 Prüfe, ob 'gdisk' installiert ist..."
if ! command -v gdisk >/dev/null 2>&1; then
    echo "📦 'gdisk' fehlt – wird jetzt installiert..."
    sudo apt update
    sudo apt install -y gdisk
else
    echo "✅ 'gdisk' ist bereits installiert."
fi

echo "🔧 Versuche GPT Backup-Header zu reparieren mit sgdisk..."
if sudo sgdisk --move-second-header "$DISK_PATH"; then
    echo "✅ GPT Backup-Header erfolgreich repariert."
else
    echo "⚠️ GPT Reparatur mit sgdisk fehlgeschlagen oder nicht nötig."
fi

echo "🔍 Vergleiche Partitionsgröße mit Diskgröße..."
disk_size=$(lsblk -bno SIZE -d "$DISK_PATH")
pv_size=$(lsblk -bno SIZE "$PV_PATH" | head -n1)

echo "Disk Größe: $disk_size Bytes"
echo "Partition Größe: $pv_size Bytes"

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
