{ pkgs, username, ... }:

{
  imports = [
    ./disk-config.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hetzner Cloud (QEMU) hardware support
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  # Networking
  networking.hostName = "vps";

  # Tailscale with SSH enabled
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--ssh" ];
  };

  # Firewall - no public SSH, Tailscale handles access
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    # No port 22 exposed - Tailscale SSH only
  };

  # Disable traditional OpenSSH - using Tailscale SSH instead
  services.openssh.enable = false;

  # System packages
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    vim
    wget
  ];

  # User account
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Allow wheel group to use sudo
  security.sudo.wheelNeedsPassword = false;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" username ];
  };

  # System state version
  system.stateVersion = "24.05";
}
