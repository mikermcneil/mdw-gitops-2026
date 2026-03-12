#!/bin/bash
# configure-cloudflare-warp.sh
# Post-install configuration for Cloudflare WARP on macOS
# Writes a managed configuration plist for Cloudflare WARP client

WARP_PLIST_DIR="/Library/Managed Preferences"
WARP_PLIST="$WARP_PLIST_DIR/com.cloudflare.warp.plist"

# Ensure the managed preferences directory exists
mkdir -p "$WARP_PLIST_DIR"

# Write the managed configuration plist
# Replace YOUR_ORG_NAME with your Cloudflare Zero Trust organization name
cat > "$WARP_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>organization</key>
    <string>YOUR_ORG_NAME</string>
    <key>auto_connect</key>
    <integer>1</integer>
    <key>switch_locked</key>
    <false/>
    <key>onboarding</key>
    <false/>
    <key>enable</key>
    <true/>
</dict>
</plist>
EOF

# Set correct ownership and permissions
chown root:wheel "$WARP_PLIST"
chmod 644 "$WARP_PLIST"

# Register the WARP client service
/Applications/Cloudflare\ WARP.app/Contents/Resources/warp-cli --accept-tos register 2>/dev/null || true

# Connect the WARP client
/Applications/Cloudflare\ WARP.app/Contents/Resources/warp-cli --accept-tos connect 2>/dev/null || true

echo "Cloudflare WARP post-install configuration applied successfully."
