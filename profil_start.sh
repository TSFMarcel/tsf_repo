#!/usr/bin/env bash

PROFILE="/home/dockervm/.profile"

BLOCK_START="# >>> FIRSTSTART BLOCK >>>"
BLOCK_END="# <<< FIRSTSTART BLOCK <<<"

BLOCK_CONTENT=$(cat << 'EOF'
# >>> FIRSTSTART BLOCK >>>
MARKER="/home/dockervm/.first_start_done"

if [[ -t 1 ]]; then
    if [[ ! -f "$MARKER" ]]; then
        /etc/scripts/update/first_start.sh
    else
        /etc/scripts/update/every_login.sh
    fi
fi
# <<< FIRSTSTART BLOCK <<<
EOF
)

# Prüfen, ob Block schon existiert
if grep -q "$BLOCK_START" "$PROFILE"; then
    echo "Block existiert bereits – überspringe."
else
    echo "Füge Block in .profile ein..."
    echo "" >> "$PROFILE"
    echo "$BLOCK_CONTENT" >> "$PROFILE"
fi

# Eigentümer korrigieren
chown dockervm:dockervm "$PROFILE"
