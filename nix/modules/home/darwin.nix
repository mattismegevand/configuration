{
  config,
  lib,
  hostname,
  configDir,
  berkeleyMonoFontDir ? null,
  ...
}:

let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ./common.nix ];

  home.file = lib.mkIf (berkeleyMonoFontDir != null) {
    "Library/Fonts/BerkeleyMono-Regular.otf".source =
      mkSymlink "${berkeleyMonoFontDir}/BerkeleyMono-Regular.otf";
    "Library/Fonts/BerkeleyMono-Bold.otf".source =
      mkSymlink "${berkeleyMonoFontDir}/BerkeleyMono-Bold.otf";
    "Library/Fonts/BerkeleyMono-Oblique.otf".source =
      mkSymlink "${berkeleyMonoFontDir}/BerkeleyMono-Oblique.otf";
    "Library/Fonts/BerkeleyMono-Bold-Oblique.otf".source =
      mkSymlink "${berkeleyMonoFontDir}/BerkeleyMono-Bold-Oblique.otf";
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
