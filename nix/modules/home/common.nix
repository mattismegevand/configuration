{ pkgs, username, ... }:

let
  configDir = ../../..;  # Points to repo root
in
{
  home = {
    username = username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "24.05";

    packages = with pkgs; [
      # AI coding tools
      claude-code
      codex

      # Core utilities
      coreutils
      curl
      git
      git-lfs
      wget

      # Modern CLI tools
      bat
      btop
      eza
      fd
      fzf
      jq
      ripgrep

      # Development
      _1password-cli
      delta
      gh
      gnupg
      hyperfine
      mise

      # Shell enhancements
      atuin
      lazygit
      tmux
      vim
      zoxide
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];

    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
    };

    file = {
      ".vimrc".source = "${configDir}/vimrc";
      ".tmux.conf".source = "${configDir}/tmux.conf";
      ".zshrc".source = "${configDir}/zshrc";
      ".aliases".source = "${configDir}/aliases";
      ".gitconfig".source = "${configDir}/gitconfig";
      ".gitignore".source = "${configDir}/gitignore";
      ".zprofile".source = "${configDir}/zprofile";
      ".psqlrc".source = "${configDir}/psqlrc";
      ".pip/pip.conf".source = "${configDir}/pip.conf";
      ".hushlogin".text = "";
    };
  };

  xdg.configFile = {
    "mise/config.toml".source = "${configDir}/config/mise/config.toml";
  };

  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = false;  # Handled in zshrc
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
