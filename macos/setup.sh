#!/bin/zsh

set -e

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

mkdir -p "$SCREENSHOT_DIR"

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

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

print "macOS preferences applied."
print "Log out and back in for keyboard repeat settings to affect every app."
