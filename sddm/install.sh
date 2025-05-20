#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} Setting up SDDM configuration..."

SDDM_SRC_DIR="$(dirname "$0")"
USERNAME="$(whoami)"
SDDM_CONF="/etc/sddm.conf.d/kde_settings.conf"
THEME_DIR_NAME="$(basename "$SDDM_SRC_DIR/theme")"

# Backup existing config
if [ -f "$SDDM_CONF" ]; then
  BACKUP_PATH="${SDDM_CONF}.bak.$(date +%Y-%m-%d_%H-%M-%S)"
  echo -e "${BLUE}[INFO]${NC} Found existing config. Backing up to '$BACKUP_PATH'..."
  sudo cp "$SDDM_CONF" "$BACKUP_PATH"
fi

# Link new kde_settings.conf
echo -e "${BLUE}[INFO]${NC} Linking new SDDM config to '$SDDM_CONF'..."
sudo mkdir -p /etc/sddm.conf.d/
sudo ln -sf "$SDDM_SRC_DIR/kde_settings.conf" "$SDDM_CONF"

# Link SDDM theme (if present)
if [ -d "$SDDM_SRC_DIR/theme" ]; then
  echo -e "${BLUE}[INFO]${NC} Found theme folder. Linking to '/usr/share/sddm/themes/$THEME_DIR_NAME'..."
  sudo ln -sfn "$SDDM_SRC_DIR/theme" "/usr/share/sddm/themes/$THEME_DIR_NAME"
else
  echo -e "${BLUE}[INFO]${NC} No theme folder found. Skipping theme link."
fi

# Set user avatar
if [ -f "$SDDM_SRC_DIR/face.icon" ]; then
  echo -e "${BLUE}[INFO]${NC} Setting user avatar..."
  cp "$SDDM_SRC_DIR/face.icon" "$HOME/.face.icon"
  sudo cp "$SDDM_SRC_DIR/face.icon" "/var/lib/AccountsService/icons/$USERNAME"
  sudo mkdir -p "/var/lib/AccountsService/users"
  sudo tee "/var/lib/AccountsService/users/$USERNAME" >/dev/null <<EOF
[User]
Icon=/var/lib/AccountsService/icons/$USERNAME
EOF
else
  echo -e "${BLUE}[INFO]${NC} No user avatar found. Skipping avatar setup."
fi

echo -e "${GREEN}[OK]${NC} SDDM configuration completed successfully."
