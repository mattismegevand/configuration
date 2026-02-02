{ ... }:

let
  configDir = ../../..;
in
{
  imports = [ ./common.nix ];

  xdg.configFile = {
    "ghostty/config".source = "${configDir}/config/ghostty/config";
    "aerospace/aerospace.toml".source = "${configDir}/config/aerospace/aerospace.toml";
  };
}
