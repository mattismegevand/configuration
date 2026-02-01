{ ... }:

{
  # macOS system preferences
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      expose-animation-duration = 0.2;
      minimize-to-application = true;
      mru-spaces = false;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
      # Disable hot corners
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf"; # Search current folder
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # List view
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    # Global macOS settings
    NSGlobalDomain = {
      # Keyboard
      AppleKeyboardUIMode = 3; # Full keyboard access
      ApplePressAndHoldEnabled = false; # Key repeat instead of accents
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      # Mouse/Trackpad
      AppleEnableMouseSwipeNavigateWithScrolls = true;
      AppleEnableSwipeNavigateWithScrolls = true;

      # General
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
    };

    # Screenshot settings
    screencapture = {
      disable-shadow = true;
      location = "~/Pictures/Screenshots";
      type = "png";
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    # Screensaver - start after 5 minutes (300 seconds)
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

  };

  # Power management - display sleep after 15 minutes
  system.activationScripts.postActivation.text = ''
    # Screensaver starts after 5 minutes
    defaults -currentHost write com.apple.screensaver idleTime -int 300
    # Display sleep after 15 minutes (value in minutes)
    sudo pmset -a displaysleep 15
  '';

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
