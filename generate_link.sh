#!/usr/bin/env bash
# Setup: Login-Hinweis + menu Befehl systemweit

MENU_SCRIPT="/etc/scripts/update/every_login.sh"
LINK_PATH="/usr/local/bin/menu"
PROFILE_D="/etc/profile.d/every_login.sh"

# ---------------- 1. Profile.d Datei ----------------
if [[ ! -f "$PROFILE_D" ]]; then
    echo "Erstelle /etc/profile.d/every_login.sh für alle Benutzer..."
    cat << EOF | sudo tee "$PROFILE_D" > /dev/null
#!/usr/bin/env bash
# >>> EVERY-LOGIN HINWEIS FÜR ALLE BENUTZER >>>

if [[ \$- == *i* ]] && [[ -t 0 ]]; then
    echo
    echo "==========================================================="
    echo "Willkommen"
    echo "Tippe 'sudo menu' um das Menü der DockerVM zu öffnen."
    echo "==========================================================="
    echo
fi

# <<< EVERY-LOGIN HINWEIS <<<
EOF
    sudo chmod +x "$PROFILE_D"
else
    echo "/etc/profile.d/every_login.sh existiert bereits – überspringe."
fi

# ---------------- 2. Symbolischer Link ----------------
if [[ ! -L "$LINK_PATH" ]]; then
    echo "Erstelle symbolischen Link $LINK_PATH → $MENU_SCRIPT"
    sudo ln -s "$MENU_SCRIPT" "$LINK_PATH"
    sudo chmod +x "$MENU_SCRIPT"
else
    echo "Symbolischer Link $LINK_PATH existiert bereits – überspringe."
fi

echo "Setup abgeschlossen!"
