#!/bin/zsh

set -e

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
CAPS_LOCK=30064771129
LEFT_CONTROL=30064771296

mkdir -p "$SCREENSHOT_DIR"

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Caps Lock to left Control for the built-in, Logitech, and HHKB keyboards.
for keyboard in 1452-641-0 1133-50503-0 1278-33-0; do
  defaults -currentHost write NSGlobalDomain \
    "com.apple.keyboard.modifiermapping.$keyboard" -array \
    "{ HIDKeyboardModifierMappingSrc = $CAPS_LOCK; HIDKeyboardModifierMappingDst = $LEFT_CONTROL; }"
done

# Mouse and scrolling
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.25

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Screenshots
defaults write com.apple.screencapture location -string "$SCREENSHOT_DIR"

killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

# Apply the mapping after restarting UI services so it remains active now.
hidutil property --set \
  "{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":$CAPS_LOCK,\"HIDKeyboardModifierMappingDst\":$LEFT_CONTROL}]}" \
  >/dev/null

print "macOS preferences applied."
print "Log out and back in for keyboard repeat settings to affect every app."
