{ pkgs, username, ... }:

{
  # Placeholder NixOS configuration
  # Customize this when setting up a Linux machine

  # Nix configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  # Basic system configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-example";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "Europe/Zurich";

  # System packages
  environment.systemPackages = with pkgs; [
    coreutils
    curl
    git
    wget
    bat
    btop
    eza
    fd
    fzf
    jq
    ripgrep
    tree
    gh
    gnupg
  ];

  # Enable zsh
  programs.zsh.enable = true;

  # User configuration
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "24.05";
}
