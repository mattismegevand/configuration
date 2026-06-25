# Remote Dev Server

Bootstrap a fresh Ubuntu server:

```sh
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/mattismegevand/configuration.git ~/configuration
cd ~/configuration
./install.sh server
```

The server profile skips desktop snaps, installs headless admin packages, enables
basic firewall defaults, allows Tailscale direct connections and tailnet traffic,
enables fail2ban and unattended upgrades, limits journald disk usage, installs
Hermes Agent, creates the `mattis` SSH user with passwordless sudo and a locked
password, syncs this configuration repo into `/home/mattis/configuration`, and
then runs `./install.sh server-user` as `mattis` so user dotfiles never land in
`/root`.

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
