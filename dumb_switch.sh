#!/bin/bash
# dumb_switch.sh

# 1. YOUR EXACT WHITELIST (These apps will ALWAYS remain active)
WHITELIST=(
    # Communication & Work
    "com.whatsapp"
    "com.Slack"
    "com.google.android.gm"             # Gmail
    "com.google.android.apps.messaging" # Messages
    "com.google.android.dialer"         # Phone
    "com.okta.android.auth"             # Okta Verify

    # Daily Utilities
    "com.google.android.calendar"       # Calendar
    "com.google.android.keep"           # Keep Notes
    "com.google.android.deskclock"      # Clock
    "com.nothing.camera1"               # Nothing Camera
    "com.android.settings"              # Settings

    # Finance, Food & Travel (Your New Additions)
    "com.amazon.mp3"                    # Amazon Music
    "com.phonepe.app"                   # PhonePe
    "com.routematic.employee"           # Routematic
    "com.dynamify.amex"                 # food2you
    "com.nothing.smartcenter"           # Nothing X
    "com.grofers.customerapp"           # Blinkit/Grofers
    "org.chennaimetrorail.appv1"        # Chennai Metro
    "com.hdfcbank.android.now"          # HDFC Bank
    "com.google.android.gms"            # Google Play Services
    "in.swiggy.android"                 # Swiggy
    "com.application.zomato"            # Zomato
    "com.rapido.passenger"              # Rapido

    # Your Minimalist Launcher
    "bitpit.launcher"                   # Niagara Launcher
)

# 2. SYSTEM DISTRACTIONS (Browsers & Pre-installed Apps to Hide)
SYSTEM_DISTRACTIONS=(
    "com.android.chrome"                      # Google Chrome
    "com.android.vending"                     # Google Play Store
    "com.google.android.youtube"              # YouTube
    "com.google.android.googlequicksearchbox" # Google App
    "com.google.android.apps.docs"            # Google Drive
    "com.google.android.apps.nbu.files"       # Files by Google
    "com.google.android.videos"               # Google TV
    "com.google.android.apps.tachyon"         # Google Meet
    "com.google.android.apps.photos"          # Google Photos
    "com.google.android.apps.youtube.music"   # YT Music
    "com.nothing.recorder"                    # Nothing Recorder (Old version)
    "com.nothing.soundrecorder"               # Nothing Sound Recorder (Current)
    "com.google.android.apps.recorder"        # Google Recorder
    "com.google.android.apps.bard"            # Google Gemini
)

if [ "$1" == "on" ]; then
    echo "Initiating Dumbphone Lockdown..."
    
    adb shell settings put global private_dns_mode opportunistic >/dev/null 2>&1
    
    # Disable system distractions
    for app in "${SYSTEM_DISTRACTIONS[@]}"; do
        echo "Checking system app: $app"
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
        echo "Restoring system app: $app"
        adb shell pm enable "$app" >/dev/null 2>&1
    done

    # Re-enable all 3rd-party apps
    ALL_THIRD_PARTY=$(adb shell pm list packages -3 -u | cut -d':' -f2 | tr -d '\r')
    for app in $ALL_THIRD_PARTY; do
        echo "Restoring 3rd-party app: $app"
        adb shell pm enable "$app" >/dev/null 2>&1
    done
    
    echo "Restoration Complete. All apps are back."

else
    echo "Usage: dumb_switch [on|off]"
fi
