# Android Setup for VS Code

Complete guide for setting up Android development on macOS with minimal tools.

## Automated Setup (Recommended)

### 1. Run the Setup Script

From your project folder:

```bash
chmod +x setup-android.sh
./setup-android.sh
```

This script will:
- ✅ Install Homebrew (if needed)
- ✅ Install Java 17
- ✅ Install Android SDK tools
- ✅ Install emulator
- ✅ Download Android 34 system image
- ✅ Create a virtual device named "CurrencyApp"

**Time**: ~10-15 minutes first run (mostly downloading)

### 2. Verify Installation

```bash
# Check Java
java -version

# Check Android SDK
sdkmanager --list_installed

# Check adb
adb --version
```

All three should return version info ✅

## Running Your App

### Quick Way (One Command)

```bash
chmod +x run-app.sh
./run-app.sh
```

This will:
1. Start the emulator automatically
2. Wait for it to boot
3. Build your app
4. Install on emulator
5. Launch the app

### Manual Steps

If you prefer more control:

```bash
# Terminal 1: Start emulator
emulator -avd CurrencyApp

# Wait 30-60 seconds, then in Terminal 2:
./gradlew installDebug

# Launch app
adb shell am start -n com.brendan.currencyapp/com.brendan.currencyapp.ui.MainActivity
```

## Viewing Logs

While app is running:

```bash
# See detailed logs from app
adb logcat | grep currencyapp

# Or verbose output
adb logcat
```

## Daily Workflow

1. **Each morning**, start emulator (keeps running):
   ```bash
   emulator -avd CurrencyApp &
   ```

2. **Edit code** in VS Code

3. **Each time you make changes**, rebuild:
   ```bash
   ./gradlew installDebug
   adb shell am start -n com.brendan.currencyapp/com.brendan.currencyapp.ui.MainActivity
   ```

4. **Emulator stays open** between sessions (just pause it)

## Useful Commands

```bash
# List all devices/emulators
adb devices

# Install APK
./gradlew installDebug

# View live logs
adb logcat

# Screen capture from emulator
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# Clear app data
adb shell pm clear com.brendan.currencyapp

# Restart app
adb shell am start -n com.brendan.currencyapp/com.brendan.currencyapp.ui.MainActivity

# Stop app
adb shell am force-stop com.brendan.currencyapp

# List installed packages
adb shell pm list packages | grep currencyapp

# View file system
adb shell

# Reboot emulator
adb reboot
```

## Troubleshooting

### Emulator won't start

```bash
# Check if already running
adb devices

# Kill all emulators
adb emu kill

# Delete and recreate device
avdmanager delete avd -n CurrencyApp
echo "no" | avdmanager create avd -n CurrencyApp -k "system-images;android-34;google_apis;arm64-v8a" -d "Pixel 6"
```

### App crashes on launch

```bash
# View crash logs
adb logcat | grep "currencyapp"

# Clear app data and reinstall
adb shell pm clear com.brendan.currencyapp
./gradlew installDebug
```

### "Could not find or load main class"

```bash
# Update Gradle wrapper
./gradlew wrapper --gradle-version latest

# Sync Gradle
./gradlew sync
```

### Gradle build fails

```bash
# Clean build
./gradlew clean

# Force rebuild
./gradlew cleanBuild assembleDebug
```

### No internet on emulator

```bash
# Emulator should have internet by default
# If not, check:
adb shell netstat | grep ESTABLISHED

# Restart emulator if needed
adb reboot
```

## Manual Setup (If Script Fails)

### Step 1: Install Java

```bash
brew install openjdk@17
echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Step 2: Install Android SDK

```bash
brew install android-sdk android-platform-tools

# Add to PATH
echo 'export ANDROID_SDK_ROOT=$(brew --prefix)/opt/android-sdk' >> ~/.zshrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"' >> ~/.zshrc
source ~/.zshrc
```

### Step 3: Accept Licenses

```bash
yes | sdkmanager --licenses
```

### Step 4: Download System Image

```bash
sdkmanager "system-images;android-34;google_apis;arm64-v8a" "emulator" "platform-tools" "platforms;android-34"
```

### Step 5: Create Emulator

```bash
echo "no" | avdmanager create avd -n CurrencyApp -k "system-images;android-34;google_apis;arm64-v8a" -d "Pixel 6"
```

## Next Steps

1. Run `./setup-android.sh` to install
2. Run `./run-app.sh` to start the app
3. Test conversion in emulator
4. Start coding in VS Code!

---

**Need help?** Check the main `README.md` or `QUICKSTART.md` for more info.
