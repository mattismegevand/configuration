# Configuration

Personal Nix, shell, git, Vim, and tmux configuration.

## Common commands

```sh
# Apply this machine's configuration
rebuild

# Update flake inputs, then apply
update

# Check formatting and flake outputs
check-config
```

The shell helpers use `$CONFIGURATION_DIR` when set, otherwise `~/configuration`.

## Layout

- `flake.nix` defines the macOS and NixOS hosts.
- `nix/hosts/` contains host-specific settings.
- `nix/modules/` contains shared Nix modules.
- Top-level dotfiles are linked by Home Manager.
