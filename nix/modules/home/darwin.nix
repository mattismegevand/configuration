{ pkgs, username, ... }:

let
  configDir = ../../..;  # Points to repo root
in
{
  imports = [ ./common.nix ];

  # macOS-specific XDG configs
  xdg.configFile = {
    "ghostty/config".source = "${configDir}/config/ghostty/config";
    "aerospace/aerospace.toml".source = "${configDir}/config/aerospace/aerospace.toml";
  };
}
