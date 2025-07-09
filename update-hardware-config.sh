#!/usr/bin/env bash

set -euo pipefail

# Get the current hostname
HOSTNAME=$(hostname)

# Path to your flake repo
FLAKE_DIR="$HOME/cjh-nix"
TARGET_PATH="$FLAKE_DIR/machines/$HOSTNAME"

# Ensure the target directory exists
mkdir -p "$TARGET_PATH"

# Copy the hardware config
cp /etc/nixos/hardware-configuration.nix "$TARGET_PATH/hardware-configuration.nix"

# Git commit
cd "$FLAKE_DIR"
git add "$TARGET_PATH/hardware-configuration.nix"
git commit -m "Update hardware config for $HOSTNAME"
