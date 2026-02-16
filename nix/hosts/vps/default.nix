{ pkgs, username, inputs, ... }:

{
  imports = [ ./disk-config.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
    kernelModules = [ "kvm-intel" "kvm-amd" ];
  };

  networking = {
    hostName = "vps";
    firewall = {
      enable = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      AllowUsers = [ username ];
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 3;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      icu
    ];
  };
  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = true;
  system.stateVersion = "24.05";

  # Build dependencies for mise-managed tools
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    openssl
    pkg-config
    zlib
    inputs.openclaw.packages.x86_64-linux.openclaw
  ];

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDN3khmVi+gULsabC9iHGTJHI1wyxoUYgBmY676o88BS mattis@macbook"
    ];
  };
}
