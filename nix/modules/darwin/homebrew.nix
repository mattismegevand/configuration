{ ... }:

{
  # Declarative Homebrew management
  homebrew = {
    enable = true;

    # Uninstall packages not listed here
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # Homebrew taps
    taps = [
    ];

    # CLI tools from Homebrew (prefer nix packages when available)
    brews = [
      "mise" # Dev tool version manager
    ];

    # GUI applications
    casks = [
      "1password"
      "brave-browser"
      "cleanshot"
      "ghostty"
      "iina"
      "orbstack"
      "stremio"
      "transmission"
      "visual-studio-code"
    ];

    # Mac App Store apps (requires mas CLI)
    masApps = {
      "NetNewsWire" = 1480640210;
      "Tailscale" = 1475387142;
    };
  };
}
