{ config, username, hostname, configDir, ... }:

let
  fontDir = "/Users/${username}/Library/Mobile Documents/com~apple~CloudDocs/misc/250223LKQVJ0407L/TX-02-4K4X9N9Y";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ./common.nix ];

  services.espanso = {
    enable = true;
    configs.default = {
      show_notifications = false;
    };
    matches = {
      base = {
        matches = [
          {
            trigger = ":li";
            replace = "https://linkedin.com/in/mattismegevand";
          }
          {
            trigger = ":gh";
            replace = "https://github.com/mattismegevand";
          }
          {
            trigger = ":web";
            replace = "https://mattismegevand.com/";
          }
        ];
      };
    };
  };

  home.file = {
    "Library/Fonts/BerkeleyMono-Regular.otf".source = mkSymlink "${fontDir}/BerkeleyMono-Regular.otf";
    "Library/Fonts/BerkeleyMono-Bold.otf".source = mkSymlink "${fontDir}/BerkeleyMono-Bold.otf";
    "Library/Fonts/BerkeleyMono-Oblique.otf".source = mkSymlink "${fontDir}/BerkeleyMono-Oblique.otf";
    "Library/Fonts/BerkeleyMono-Bold-Oblique.otf".source = mkSymlink "${fontDir}/BerkeleyMono-Bold-Oblique.otf";
  };

  xdg.configFile = {
    "ghostty/config".source = "${configDir}/config/ghostty/config";
    "1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      item = "${hostname}"
      vault = "Personal"
    '';
  };
}
