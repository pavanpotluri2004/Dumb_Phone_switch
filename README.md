# Dumb_Phone_switch
This is a script that you can run from your laptop (i think only ubuntu) to dsable the apps on your mobile except for the required ones and this can reverted only when you connect your mobile to the laptop and run the script
# Dumbphone Lockdown Script

This script transforms an Android smartphone (like the Nothing Phone 3 or OnePlus) into a minimalist "dumbphone" by using the Android Debug Bridge (ADB) to disable all distracting applications at the system level. 

It uses a strict **Whitelist Approach**: preserving essential utilities (communication, navigation, camera) and your minimalist launcher (e.g., Niagara Launcher) while completely hiding web browsers and unapproved third-party apps.

## 📱 Step 1: Phone Preparation

Before using the script, you must configure your Android device to accept ADB commands.

1. **Enable Developer Mode:**
   * Go to `Settings` > `About phone` (or `Software info`).
   * Tap `Build number` 7 times until it says "You are now a developer!"
2. **Enable USB Debugging:**
   * Go back to the main `Settings` menu.
   * Navigate to `System` > `Developer options`.
   * Scroll down and toggle **USB debugging** to `ON`.
3. **Set Default Launcher:**
   * Install your minimalist launcher (e.g., Niagara Launcher).
   * Go to `Settings` > `Apps` > `Default apps` > `Home app` and select it.

## 💻 Step 2: Laptop Setup (Ubuntu/Linux)

Install the required ADB tools on your computer.

1. Open your terminal and install ADB:
   ```bash
   sudo apt update
   sudo apt install adb
   ```
2. Plug your phone into your laptop via USB.
3. Start the ADB server with administrator privileges (this prevents Ubuntu USB permission errors):
   ```bash
   adb kill-server
   sudo adb start-server
   ```
4. Verify the connection:
   ```bash
   adb devices
   ```
   *Look at your phone screen! Check the box that says "Always allow from this computer" and tap **Allow**.* The terminal should now list your device ID followed by the word `device`.

## ⚙️ Step 3: Script Installation

1. Create the file on your computer:
   ```bash
   nano dumb_switch.sh
   ```
2. Paste the provided bash script into the editor, then save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).
3. Make the script executable:
   ```bash
   chmod +x dumb_switch.sh
   ```
4. **(Optional but Recommended)** Move the script to your system bin so you can run it from anywhere without needing the `./` prefix:
   ```bash
   sudo mv dumb_switch.sh /usr/local/bin/dumb_switch
   ```

## 🚀 Usage

With your phone connected and unlocked:

**To initiate the lockdown (hide all non-whitelisted apps & browsers):**
```bash
dumb_switch on
```
*(If you didn't move it to the bin, run `./dumb_switch.sh on` from the folder it is saved in).*

**To restore to normal smartphone mode:**
```bash
dumb_switch off
```

## 🔍 Helpful ADB Commands for Customization

If you need to add new apps to your script's `WHITELIST` array later, you will need their exact Android package names. Use these commands in your terminal while your phone is plugged in:

**Method 1: Find the currently open app (Most Accurate)**
Open the app you want to identify on your phone screen, then run:
```bash
adb shell dumpsys window | grep -i mCurrentFocus
```

**Method 2: Search for an app by keyword**
Search your phone's installed packages for a specific word (e.g., "calc"):
```bash
adb shell pm list packages | grep -i calc
```

**Method 3: View all third-party apps**
List every app you have downloaded from the Play Store:
```bash
adb shell pm list packages -3
```

## ⚠️ Important Warnings
* **Do not disable core system apps** (System UI, Keyboard, Dialer) as it can cause bootloops. The script is designed to safely ignore them by targeting `-3` (third-party) apps, but edit the `SYSTEM_DISTRACTIONS` list with caution.
* If you change your minimalist launcher in the future, you **must** update the `WHITELIST` in the script with the new launcher's package name before running it, or you will be left without a home screen.