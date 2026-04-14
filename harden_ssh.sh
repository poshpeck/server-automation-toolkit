#!/bin/bash

# ============================================
# SSH Hardening Script
# Disables root login, enforces key-only auth
# ============================================

set -euo pipefail

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="$SSHD_CONFIG.bak_$(date +%Y%m%d_%H%M%S)"

log() {
  echo "$1"
}

# --- Must run as root ---
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root: sudo ./harden_ssh.sh"
  exit 1
fi

log "============================================"
log " SSH Hardening — $(date '+%Y-%m-%d %H:%M:%S')"
log "============================================"

# --- Step 1: Backup first --- 
log "[1/5] Backing up sshd_config..."
cp "$SSHD_CONFIG" "$BACKUP"
log "  [OK] Backup saved to $BACKUP"

# --- Step 2: Disable root login ---
log "[2/5] Disabling root login..."
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
log "  [OK] PermitRootLogin set to no"

# --- Step 3: Disable password authentication ---
log "[3/5] Enforcing key-only authentication..."
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
log "  [OK] PasswordAuthentication set to no"

# --- Step 4: Apply other hardening settings ---
log "[4/5] Applying additional hardening..."

# Remove existing entries to avoid duplicates, then append clean values
sed -i '/^#*X11Forwarding/d' "$SSHD_CONFIG"
sed -i '/^#*MaxAuthTries/d' "$SSHD_CONFIG"
sed -i '/^#*LoginGraceTime/d' "$SSHD_CONFIG"
sed -i '/^#*AllowAgentForwarding/d' "$SSHD_CONFIG"

cat >> "$SSHD_CONFIG" << 'EOF'

# --- Hardening additions ---
X11Forwarding no
MaxAuthTries 3
LoginGraceTime 20
AllowAgentForwarding no
EOF

log "  [OK] X11Forwarding disabled"
log "  [OK] MaxAuthTries set to 3"
log "  [OK] LoginGraceTime set to 20s"
log "  [OK] AllowAgentForwarding disabled"

# --- Step 5: Validate config before restarting ---
log "[5/5] Validating sshd config..."
if sshd -t; then
  log "  [OK] Config is valid"
  systemctl restart ssh
  log "  [OK] SSH service restarted"
else
  log "  [ERROR] Config validation failed — restoring backup"
  cp "$BACKUP" "$SSHD_CONFIG"
  log "  [OK] Backup restored — no changes made"
  exit 1
fi

log "============================================"
log " Hardening complete."
log " Backup stored at: $BACKUP"
log "============================================"
