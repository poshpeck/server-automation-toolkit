#!/bin/bash

# ============================================
# Server Automation Toolkit — setup.sh
# Phase 1 Project | DevOps Learning
# ============================================

set -euo pipefail

echo "============================================"
echo " Starting server setup..."
echo "============================================"

# --- 1. Update the system ---
echo "[1/5] Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# --- 2. Install essential tools ---
echo "[2/5] Installing essential tools..."
sudo apt-get install -y \
  curl \
  wget \
  git \
  htop \
  ufw \
  unzip \
  net-tools \
  tree

# --- 3. Confirm installations ---
echo "[3/5] Verifying installs..."
for tool in curl wget git htop ufw tree; do
  if command -v $tool &> /dev/null; then
    echo "  [OK] $tool installed"
  else
    echo "  [FAILED] $tool not found"
  fi
done

# --- 4. Create project log directory ---
echo "[4/5] Creating log directory..."
mkdir -p ~/devops/logs
echo "  [OK] ~/devops/logs created"

# --- 5. Done ---
echo "[5/5] Setup complete."
echo "============================================"
