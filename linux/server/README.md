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
enables fail2ban and unattended upgrades, limits journald disk usage, creates
the `mattis` SSH user with sudo group membership, syncs
this configuration repo into `/home/mattis/configuration`, and then runs
`./install.sh server-user` as `mattis` so user dotfiles never land in `/root`.

Before running it on a public server, make sure SSH key login works. The script
allows `OpenSSH`, `41641/udp` for Tailscale, and inbound traffic on
`tailscale0` in UFW before enabling the firewall.

## Manual post-bootstrap steps

Set a password for `mattis` if you want password-based sudo:

```sh
sudo passwd mattis
```

Tailscale is installed and `tailscaled` is enabled for all Linux profiles. Log in
after installation:

```sh
sudo tailscale up
```

Authenticate account-bound tools manually after bootstrap:

```sh
gh auth login
```

Keep these manual too: 1Password sign-in and SSH agent approvals, VS Code
Settings Sync or account login, browser/app approvals, and any secret-bearing
dotfiles such as SSH keys, API tokens, or package registry credentials.
