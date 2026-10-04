#!/bin/bash
# dumb_switch.sh

# 1. YOUR EXACT WHITELIST
WHITELIST=(
    # Communication & Work
    "com.whatsapp"
    "com.Slack"
    "com.google.android.gm"             # Gmail
    "com.google.android.apps.messaging" # Messages
    "com.google.android.dialer"         # Phone (System app, added for safety)
    "com.okta.android.auth"             # Okta Verify

    # Daily Utilities
    "com.google.android.calendar"       # Calendar
    "com.google.android.keep"           # Keep Notes
    "com.google.android.deskclock"      # Clock
    "com.google.android.apps.photos"    # Gallery / Google Photos
    "com.nothing.camera1"               # Nothing Camera
    "com.android.settings"              # Settings

    # Third-Party Apps
    "com.amazon.mp3"                    # Amazon Music
    "com.phonepe.app"                   # PhonePe
    "com.routematic.employee"           # Routematic
    "com.dynamify.amex"                 # food2you
    "com.nothing.smartcenter"           # Nothing X

    # Your Minimalist Launcher
    "bitpit.launcher"                   # Niagara Launcher
)

# 2. SYSTEM DISTRACTIONS (Browsers & Feeds)
SYSTEM_DISTRACTIONS=(
    "com.android.chrome"                      # Google Chrome
    "com.google.android.youtube"              # YouTube
    "com.google.android.googlequicksearchbox" # Google App
)

if [ "$1" == "on" ]; then
    echo "Initiating Dumbphone Lockdown..."
    
    # Remove the NextDNS filter if it was active from previous tests
    adb shell settings put global private_dns_mode opportunistic >/dev/null 2>&1
    
    # Disable system distractions (Chrome, YouTube)
    for app in "${SYSTEM_DISTRACTIONS[@]}"; do
        adb shell pm disable-user --user 0 "$app" >/dev/null 2>&1
    done

    # Disable all 3rd-party apps NOT in the whitelist
    THIRD_PARTY_APPS=$(adb shell pm list packages -3 | cut -d':' -f2 | tr -d '\r')
    for app in $THIRD_PARTY_APPS; do
        if [[ ! " ${WHITELIST[*]} " =~ " ${app} " ]]; then
            echo "Disabling distraction: $app"
            adb shell pm disable-user --user 0 "$app" >/dev/null 2>&1
        fi
    done
    
    echo "Lockdown Complete. Only your curated apps are active."

elif [ "$1" == "off" ]; then
    echo "Restoring Smartphone Mode..."
    
    # Re-enable system distractions
    for app in "${SYSTEM_DISTRACTIONS[@]}"; do
        adb shell pm enable "$app" >/dev/null 2>&1
    done

    # Re-enable all 3rd-party apps
    ALL_THIRD_PARTY=$(adb shell pm list packages -3 -u | cut -d':' -f2 | tr -d '\r')
    for app in $ALL_THIRD_PARTY; do
        adb shell pm enable "$app" >/dev/null 2>&1
    done
    
    echo "Restoration Complete. All apps are back."

else
    echo "Usage: ./dumb_switch.sh [on|off]"
fi