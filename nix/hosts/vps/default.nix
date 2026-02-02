{ lib, pkgs, username, ... }:

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

  # Tailscale for convenient access
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--ssh" ];
  };

  # Standard SSH with key authentication (no passwords)
  services.openssh = {
    enable = lib.mkForce true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # Firewall allows SSH (port 22) and Tailscale
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    bat
    curl
    eza
    git
    htop
    mise
    vim
    wget

    # Build dependencies for mise-managed tools
    gcc
    gnumake
    openssl
    pkg-config
    zlib
  ];

  # User account
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDN3khmVi+gULsabC9iHGTJHI1wyxoUYgBmY676o88BS mattis@macbook"
    ];
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
