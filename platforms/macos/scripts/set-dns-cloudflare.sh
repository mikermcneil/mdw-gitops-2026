#!/bin/bash
# set-dns-cloudflare.sh
# Sets DNS to Cloudflare's 1.1.1.1 and 1.0.0.1 on all active network interfaces

# Get list of network services
while IFS= read -r service; do
    if [ -n "$service" ]; then
        # Set DNS servers to Cloudflare
        networksetup -setdnsservers "$service" 1.1.1.1 1.0.0.1
        echo "Set DNS to Cloudflare (1.1.1.1, 1.0.0.1) for: $service"
    fi
done <<< "$(networksetup -listallnetworkservices | tail -n +2)"

# Flush DNS cache
dscacheutil -flushcache
killall -HUP mDNSResponder 2>/dev/null

echo "DNS configuration updated to Cloudflare (1.1.1.1) successfully."
