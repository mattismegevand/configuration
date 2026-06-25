#!/bin/sh
set -eu

sudo install -d -m 755 /etc/systemd/journald.conf.d
printf '%s\n' '[Journal]' 'SystemMaxUse=1G' 'RuntimeMaxUse=512M' |
  sudo tee /etc/systemd/journald.conf.d/10-size-limits.conf >/dev/null
sudo systemctl restart systemd-journald

sudo systemctl enable --now fail2ban
sudo dpkg-reconfigure -f noninteractive unattended-upgrades

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow 41641/udp comment 'Tailscale direct connections'
sudo ufw allow in on tailscale0
sudo ufw --force enable

curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup

if command -v zsh >/dev/null 2>&1 && [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  sudo chsh -s "$(command -v zsh)" "$USER"
fi
