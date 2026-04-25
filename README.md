# Devops Server Automation Toolkit

A bash-based toolkit for bootstrapping, monitoring, and hardening Ubuntu servers.

## Scripts

| Script | Purpose |
|--------|---------|
| setup.sh | Installs and verifies essential server tools |
| health_check.sh | Reports CPU, memory, disk and service status |
| harden_ssh.sh | Hardens SSH config to production standard |

## Usage

```bash
# Bootstrap a fresh server
sudo ./setup.sh

# Run a health check
./health_check.sh

# Harden SSH (run once after setup)
sudo ./harden_ssh.sh
```

## Health Check Output Example
[CPU]  Load average (1 min): 0.03
[MEM]  Used: 669MB / 15867MB (4%)
[DISK] Used: 25G / 1007G (3%)
[SERVICES]
[OK]   ssh is running
[OK]   ufw is running
[UP]   up 3 hours, 48 minutes# Server Automation Toolkit

A bash-based toolkit for bootstrapping, monitoring, and hardening Ubuntu servers.

## Scripts

| Script | Purpose |
|--------|---------|
| setup.sh | Installs and verifies essential server tools |
| health_check.sh | Reports CPU, memory, disk and service status |
| harden_ssh.sh | Hardens SSH config to production standard |

## Usage

```bash
# Bootstrap a fresh server
sudo ./setup.sh

# Run a health check
./health_check.sh

# Harden SSH (run once after setup)
sudo ./harden_ssh.sh
```

## Health Check Output Example
[CPU]  Load average (1 min): 0.03
[MEM]  Used: 669MB / 15867MB (4%)
[DISK] Used: 25G / 1007G (3%)
[SERVICES]
[OK]   ssh is running
[OK]   ufw is running
[UP]   up 3 hours, 48 minutes
## Cron Schedule

Health check runs automatically every hour via cron.
Logs are stored in `./logs/health_YYYY-MM-DD.log`
