#!/bin/sh
set -eu

server_user=mattis
server_user_home="/home/$server_user"
server_user_shell=/usr/bin/zsh
server_user_authorized_keys="$PWD/linux/server/users/$server_user/authorized_keys"

if ! getent passwd "$server_user" >/dev/null; then
  sudo useradd -m -s "$server_user_shell" "$server_user"
fi

sudo usermod -s "$server_user_shell" "$server_user"
sudo passwd -l "$server_user" >/dev/null
sudo install -d -m 700 -o "$server_user" -g "$server_user" "$server_user_home/.ssh"
sudo install -m 600 -o "$server_user" -g "$server_user" \
  "$server_user_authorized_keys" "$server_user_home/.ssh/authorized_keys"

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
