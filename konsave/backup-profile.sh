#!/bin/bash

set -e

if ! command -v konsave &>/dev/null; then
  echo "[ERROR] 'konsave' is not installed. Please install it first."
  exit 1
fi

PROFILE_NAME="minimal-setup"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
OUTPUT_DIR="$(dirname "$0")/profiles"
BASENAME="${PROFILE_NAME}-${TIMESTAMP}"
EXPORT_DIR="$OUTPUT_DIR"
ZIP_PATH="${OUTPUT_DIR}/${BASENAME}.zip"

mkdir -p "$OUTPUT_DIR"

echo "[INFO] Removing existing profile '${PROFILE_NAME}' if it exists..."
konsave -r "$PROFILE_NAME" 2>/dev/null || true

echo "[INFO] Saving current profile as '${PROFILE_NAME}'..."
konsave -s "$PROFILE_NAME"

echo "[INFO] Exporting profile as '${ZIP_PATH}'..."
konsave -e "$PROFILE_NAME" -d "$EXPORT_DIR" -n "$(basename "$ZIP_PATH")"

echo "[OK] Backup created at: $ZIP_PATH"
