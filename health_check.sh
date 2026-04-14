#!/bin/bash

# ============================================
# Server Health Check
# Logs CPU, memory, disk, and services
# ============================================

set -euo pipefail

# --- Config ---
LOG_DIR="$HOME/devops/logs"
LOG_FILE="$LOG_DIR/health_$(date +%Y-%m-%d).log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DISK_THRESHOLD=80
MEM_THRESHOLD=80

# --- Ensure log dir exists ---
mkdir -p "$LOG_DIR"

# --- Helper: write to log and screen ---
log() {
  echo "$1" | tee -a "$LOG_FILE"
}

# ============================================
log ""
log "============================================"
log " Health Check — $TIMESTAMP"
log "============================================"

# --- CPU load ---
CPU_LOAD=$(top -bn1 | grep "load average" | awk '{print $10}' | tr -d ',')
log "[CPU]  Load average (1 min): $CPU_LOAD"

# --- Memory ---
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_USED=$(free -m | awk '/^Mem:/{print $3}')
MEM_PCT=$(awk "BEGIN {printf \"%d\", ($MEM_USED/$MEM_TOTAL)*100}")
log "[MEM]  Used: ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PCT}%)"

if [ "$MEM_PCT" -gt "$MEM_THRESHOLD" ]; then
  log "[WARN] Memory usage above ${MEM_THRESHOLD}%!"
fi

# --- Disk ---
DISK_PCT=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
log "[DISK] Used: ${DISK_USED} / ${DISK_TOTAL} (${DISK_PCT}%)"

if [ "$DISK_PCT" -gt "$DISK_THRESHOLD" ]; then
  log "[WARN] Disk usage above ${DISK_THRESHOLD}%!"
fi

# --- Services check ---
log "[SERVICES]"
SERVICES=("ssh" "ufw")
for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
    log "  [OK]   $service is running"
  else
    log "  [DOWN] $service is NOT running"
  fi
done

# --- Uptime ---
UPTIME=$(uptime -p)
log "[UP]   $UPTIME"

log "============================================"
log ""
