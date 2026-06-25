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

if command -v zsh >/dev/null 2>&1; then
  login_shell="$(command -v zsh)"
  if [ "${SHELL:-}" != "$login_shell" ]; then
    sudo chsh -s "$login_shell" "$USER"
  fi
  export SHELL="$login_shell"
fi

hermes_installer="$(mktemp)"
trap 'rm -f "$hermes_installer"' EXIT
curl -fsSL https://hermes-agent.nousresearch.com/install.sh -o "$hermes_installer"
bash "$hermes_installer" --skip-setup --non-interactive
