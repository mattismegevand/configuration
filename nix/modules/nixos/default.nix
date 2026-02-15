{ username, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraUpFlags = [ "--ssh" ];
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" username ];
      extra-substituters = [ "https://cache.garnix.io" ];
      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    randomizedDelaySec = "45min";
    allowReboot = true;
  };
}
