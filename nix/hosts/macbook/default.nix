{ pkgs, username, ... }:

{
  # Let Determinate Nix manage the nix daemon
  nix.enable = false;

  # System packages (macOS-specific, shared tools are in home-manager)
  environment.systemPackages = with pkgs; [
    # These are needed at system level on macOS
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
