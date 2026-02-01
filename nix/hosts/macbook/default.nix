{ pkgs, username, ... }:

{
  # Let Determinate Nix manage the nix daemon
  nix.enable = false;

  # System packages available globally
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils
    curl
    git
    wget

    # Modern CLI tools
    bat
    btop
    eza
    fd
    fzf
    jq
    ripgrep

    # Development
    delta
    gh
    gnupg
    hyperfine

    # Shell enhancements
    atuin
    direnv
    lazygit
    zoxide
  ];

  # Create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # Used for backwards compatibility
  system.stateVersion = 5;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User configuration
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Primary user for system.defaults and homebrew
  system.primaryUser = username;
}
