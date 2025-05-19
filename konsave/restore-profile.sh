#!/bin/bash

set -e

if ! command -v konsave &>/dev/null; then
  echo "[ERROR] 'konsave' is not installed. Please install it first."
  exit 1
fi

if [ $# -ne 1 ]; then
  echo "Usage: $0 <profile-name>"
  echo "Example: $0 minimal-setup-2025-05-19_17-34"
  exit 1
fi

PROFILE_NAME="$1"
BACKUP_DIR="$(dirname "$0")/profiles"
ZIP_PATH="${BACKUP_DIR}/${PROFILE_NAME}.knsv.zip"

if [ ! -f "$ZIP_PATH" ]; then
  echo "[ERROR] Backup file not found: $ZIP_PATH"
  exit 1
fi

echo "[INFO] Importing profile from '$ZIP_PATH'..."
konsave -i "$ZIP_PATH"

echo "[INFO] Applying profile '$PROFILE_NAME'..."
konsave -a "$PROFILE_NAME"

echo "[OK] Profile '$PROFILE_NAME' restored successfully."
