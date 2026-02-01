{ pkgs, username, ... }:

{
  # Tailscale with SSH enabled (keyless access via tailnet identity)
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--ssh" ];
  };

  # Firewall defaults - no public SSH port
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
  };

  # Disable traditional SSH - Tailscale SSH handles access
  services.openssh.enable = false;

  # Common server packages
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    vim
    wget
  ];

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" username ];
  };
}
