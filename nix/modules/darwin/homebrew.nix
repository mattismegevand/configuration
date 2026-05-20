{ ... }:

{
  # Declarative Homebrew management
  homebrew = {
    enable = true;

    # Uninstall packages not listed here
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };

    # Homebrew taps
    taps = [
    ];

    # CLI tools from Homebrew (prefer nix packages when available)
    brews = [
      "mole" # macOS system optimization tool
    ];

    # GUI applications
    casks = [
      "1password"
      "brave-browser"
      "cleanshot"
      "ghostty"
      "iina"
      "netnewswire"
      "orbstack"
      "tailscale-app"
      "transmission"
      "visual-studio-code"
    ];
  };
}
