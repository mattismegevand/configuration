{ pkgs, username, ... }:

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
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "24.05";

  # Build dependencies for mise-managed tools
  environment.systemPackages = with pkgs; [ gcc gnumake openssl pkg-config zlib ];

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
