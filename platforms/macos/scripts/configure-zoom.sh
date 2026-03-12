#!/bin/bash
# configure-zoom.sh
# Post-install configuration for Zoom on macOS
# Sets common enterprise managed preferences via defaults write

PLIST_DOMAIN="us.zoom.config"

# Disable automatic update prompts (managed via Fleet instead)
defaults write "$PLIST_DOMAIN" ZAutoUpdate -bool false

# Suppress first-run welcome dialog
defaults write "$PLIST_DOMAIN" ZAutoSSOLogin -bool true
defaults write "$PLIST_DOMAIN" ZSSOHost "yourcompany.zoom.us"
defaults write "$PLIST_DOMAIN" nogoogle -bool true
defaults write "$PLIST_DOMAIN" nofacebook -bool true

# Suppress feedback prompts
defaults write "$PLIST_DOMAIN" ZAutoFitWhenViewShare -bool true
defaults write "$PLIST_DOMAIN" ZDisableVideo -bool false
defaults write "$PLIST_DOMAIN" ZHideNoSSO -bool true

# Enable SSO login by default
defaults write "$PLIST_DOMAIN" enableSSO -bool true

# Set audio to auto-join with computer audio
defaults write "$PLIST_DOMAIN" ZAutoJoinVOIP -bool true

# Mute microphone on join by default
defaults write "$PLIST_DOMAIN" MuteVoipWhenJoin -bool true

echo "Zoom post-install configuration applied successfully."
