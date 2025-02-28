#!/bin/bash

# Firefox Developer Edition Profile Path (Adjust if needed)
# FIREFOX_PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.dev-edition-default" | head -n 1)
FIREFOX_PROFILE=/home/tr/.mozilla/firefox/0ghc7zkp.dev-edition-default-2
PREFS_FILE="$FIREFOX_PROFILE/user.js"

if [ -z "$FIREFOX_PROFILE" ]; then
    echo "Firefox Developer Edition profile not found! Ensure it's installed and run at least once."
    exit 1
fi

# Create a user.js file if not exists
touch "$PREFS_FILE"

# Apply optimizations
echo "Applying Firefox Developer Edition optimizations..."
cat <<EOF > "$PREFS_FILE"
// Enable hardware acceleration
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);

// Increase content process limit
user_pref("dom.ipc.processCount", 8);

// Enable HTTP/3 for faster browsing
user_pref("network.http.http3.enabled", true);

// Disable telemetry and data collection
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("browser.ping-centre.telemetry", false);

// Enable DNS over HTTPS (DoH)
user_pref("network.trr.mode", 2);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// Disable animations for performance
user_pref("toolkit.cosmeticAnimations.enabled", false);
user_pref("ui.prefersReducedMotion", 1);

// Optimize caching
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);

// Disable Pocket & Other Unnecessary Services
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
EOF

# Apply system-wide optimizations
echo "Applying system-wide optimizations..."
export MOZ_DISABLE_SAFE_MODE_KEY=1
export MOZ_USE_XINPUT2=1

# Restart Firefox Developer Edition
echo "Optimizations applied! Restarting Firefox Developer Edition..."
pkill firefox && firefox-developer-edition &

echo "Done! 🚀"
