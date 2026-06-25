# Remote Dev Server

Bootstrap a fresh Ubuntu server:

```sh
sudo apt-get update
sudo apt-get install -y git
git clone git@github.com:mattis/configuration.git ~/configuration
cd ~/configuration
./install.sh server
```

The server profile skips desktop snaps, installs headless admin packages, enables
basic firewall defaults, allows Tailscale direct connections and tailnet traffic,
enables fail2ban and unattended upgrades, limits journald disk usage, installs
Hermes Agent, and switches the login shell to zsh.

Before running it on a public server, make sure SSH key login works. The script
allows `OpenSSH`, `41641/udp` for Tailscale, and inbound traffic on
`tailscale0` in UFW before enabling the firewall.

Hermes Agent is installed with the official terminal installer. Reload the shell
after bootstrap, then run first-time setup from an SSH session:

```sh
source ~/.zshrc
hermes setup --portal
hermes gateway setup
```

Tailscale is installed and `tailscaled` is enabled for all Linux profiles. Log in
after installation with:

```sh
sudo tailscale up
```
