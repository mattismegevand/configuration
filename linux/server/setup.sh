#!/bin/sh
set -eu

server_user=mattis
server_user_home="/home/$server_user"
server_user_repo="$server_user_home/configuration"
server_user_shell=/usr/bin/zsh
server_user_authorized_keys="$PWD/linux/server/users/$server_user/authorized_keys"
configuration_repo_url=https://github.com/mattismegevand/configuration.git

if [ "$(id -u)" -ne 0 ]; then
  printf 'linux/server/setup.sh must be run as root.\n' >&2
  exit 1
fi

printf 'Server bootstrap: user=%s home=%s repo=%s\n' \
  "$server_user" "$server_user_home" "$server_user_repo"

if ! getent passwd "$server_user" >/dev/null; then
  sudo useradd -m -s "$server_user_shell" -G sudo "$server_user"
fi

sudo usermod -s "$server_user_shell" "$server_user"
sudo usermod -aG sudo "$server_user"
sudo passwd -l "$server_user" >/dev/null
sudo install -d -m 700 -o "$server_user" -g "$server_user" "$server_user_home/.ssh"
sudo install -m 600 -o "$server_user" -g "$server_user" \
  "$server_user_authorized_keys" "$server_user_home/.ssh/authorized_keys"
printf '%s\n' "$server_user ALL=(ALL) NOPASSWD:ALL" |
  sudo tee "/etc/sudoers.d/90-$server_user" >/dev/null
sudo chmod 440 "/etc/sudoers.d/90-$server_user"

if [ ! -d "$server_user_repo/.git" ]; then
  sudo -H -u "$server_user" git clone "$configuration_repo_url" "$server_user_repo"
else
  sudo -H -u "$server_user" git -C "$server_user_repo" pull --ff-only
fi

sudo -H -u "$server_user" "$server_user_repo/install.sh" server-user

sudo install -d -m 755 /etc/systemd/journald.conf.d
printf '%s\n' '[Journal]' 'SystemMaxUse=1G' 'RuntimeMaxUse=512M' |
  sudo tee /etc/systemd/journald.conf.d/10-size-limits.conf >/dev/null
sudo systemctl restart systemd-journald

sudo install -d -m 755 /etc/fail2ban/jail.d
printf '%s\n' \
  '[DEFAULT]' \
  'ignoreip = 127.0.0.1/8 ::1 100.67.47.63' |
  sudo tee /etc/fail2ban/jail.d/10-ignore-tailnet.conf >/dev/null
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
