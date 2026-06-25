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
basic firewall defaults, allows Tailscale traffic, enables fail2ban and
unattended upgrades, limits journald disk usage, installs Hermes Agent, and
switches the login shell to zsh.

Before running it on a public server, make sure SSH key login works. The script
allows `OpenSSH` in UFW and then enables the firewall.

Hermes Agent is installed non-interactively, so first-run configuration is left
for an SSH session:

```sh
hermes setup
hermes gateway
```

Tailscale is installed and `tailscaled` is enabled for all Linux profiles. Log in
after installation with:

```sh
sudo tailscale up
```
