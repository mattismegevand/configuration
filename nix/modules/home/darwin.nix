{ username, ... }:

let
  configDir = ../../..;
  fontDir = "/Users/${username}/Library/Mobile Documents/com~apple~CloudDocs/misc/250223LKQVJ0407L/TX-02-4K4X9N9Y";
in
{
  imports = [ ./common.nix ];

  home.file = {
    "Library/Fonts/BerkeleyMono-Regular.otf".source = "${fontDir}/BerkeleyMono-Regular.otf";
    "Library/Fonts/BerkeleyMono-Bold.otf".source = "${fontDir}/BerkeleyMono-Bold.otf";
    "Library/Fonts/BerkeleyMono-Oblique.otf".source = "${fontDir}/BerkeleyMono-Oblique.otf";
    "Library/Fonts/BerkeleyMono-Bold-Oblique.otf".source = "${fontDir}/BerkeleyMono-Bold-Oblique.otf";
  };

  xdg.configFile = {
    "ghostty/config".source = "${configDir}/config/ghostty/config";
    "aerospace/aerospace.toml".source = "${configDir}/config/aerospace/aerospace.toml";
  };
}
