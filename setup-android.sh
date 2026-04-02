#!/bin/bash

# Currency App - Android Setup Script for macOS
# This script installs minimal Android SDK tools and creates an emulator

set -e

echo "🚀 Currency App - Android Development Setup"
echo "==========================================="
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew found"
fi

echo ""
echo "📦 Installing Android SDK tools..."
echo ""

# Install Java (required for Android development)
if ! command -v java &> /dev/null; then
    echo "Installing Java 17..."
    brew install openjdk@17
fi

# Set Java path - try both possible locations
if [ -d "/usr/local/opt/openjdk@17" ]; then
    export JAVA_HOME="/usr/local/opt/openjdk@17"
elif [ -d "/opt/homebrew/opt/openjdk@17" ]; then
    export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
else
    # Fall back to java_home command
    export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || echo "")
fi

if [ -z "$JAVA_HOME" ]; then
    echo "❌ Could not find Java 17. Please install it:"
    echo "   brew install openjdk@17"
    exit 1
fi

echo "✅ Java found at: $JAVA_HOME"
export PATH="$JAVA_HOME/bin:$PATH"

# Set up Android SDK directory
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/emulator"

# Add to shell profile for future sessions
if ! grep -q "ANDROID_SDK_ROOT" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Android SDK Configuration" >> ~/.zshrc
    echo "export JAVA_HOME=\"\$(/usr/libexec/java_home -v 17 2>/dev/null || echo '')\"" >> ~/.zshrc
    echo "export ANDROID_SDK_ROOT=\"\$HOME/Library/Android/sdk\"" >> ~/.zshrc
    echo "export PATH=\"\$JAVA_HOME/bin:\$PATH:\$ANDROID_SDK_ROOT/platform-tools:\$ANDROID_SDK_ROOT/tools/bin:\$ANDROID_SDK_ROOT/emulator\"" >> ~/.zshrc
fi

# Download and install Android SDK Command-line Tools
if [ ! -d "$ANDROID_SDK_ROOT/cmdline-tools/latest" ]; then
    echo "Downloading Android SDK Command-line Tools..."
    mkdir -p "$ANDROID_SDK_ROOT"
    
    TOOLS_ZIP="/tmp/cmdline-tools.zip"
    
    # Download for macOS
    curl -s "https://dl.google.com/android/repository/commandlinetools-mac-8512546_latest.zip" -o "$TOOLS_ZIP"
    
    if [ ! -f "$TOOLS_ZIP" ]; then
        echo "❌ Failed to download Android SDK tools"
        echo "Try manual installation from: https://developer.android.com/studio/command-line-tools"
        exit 1
    fi
    
    # Extract and organize
    mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"
    unzip -q "$TOOLS_ZIP" -d "$ANDROID_SDK_ROOT/cmdline-tools"
    mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"
    rm "$TOOLS_ZIP"
    
    echo "✅ Android SDK Command-line Tools installed"
else
    echo "✅ Android SDK Command-line Tools already installed"
fi

echo ""
echo "📱 Setting up Android Emulator..."
echo ""

# Reload PATH with new SDK tools
export SDKMANAGER="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
export AVDMANAGER="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/avdmanager"

# Accept Android licenses
echo "Accepting Android licenses (this may take a moment)..."
yes | "$SDKMANAGER" --licenses > /dev/null 2>&1 || true

# Install Android 34 system image and tools
echo "Downloading Android 34 system image and tools (this may take 10-15 minutes)..."
"$SDKMANAGER" "system-images;android-34;google_apis;arm64-v8a" "emulator" "platform-tools" "platforms;android-34" --verbose

# Create emulator
echo ""
echo "Creating virtual device 'CurrencyApp'..."
"$AVDMANAGER" delete avd -n CurrencyApp 2>/dev/null || true
echo "no" | "$AVDMANAGER" create avd -n CurrencyApp -k "system-images;android-34;google_apis;arm64-v8a" -d "Pixel 6"

echo ""
echo "✅ Setup Complete!"
echo ""
echo "📋 Next Steps:"
echo "=============="
echo ""
echo "1. Start the emulator in a separate terminal:"
echo "   emulator -avd CurrencyApp"
echo ""
echo "2. Wait 30-60 seconds for Android to boot"
echo ""
echo "3. In your project folder, build and install the app:"
echo "   ./gradlew installDebug"
echo ""
echo "4. Launch the app on the emulator:"
echo "   adb shell am start -n com.brendan.currencyapp/com.brendan.currencyapp.ui.MainActivity"
echo ""
echo "5. (Optional) Open app in VS Code:"
echo "   code /Users/anzellecooney/Documents/Brendan\ Stuff/Development/currency-app"
echo ""
echo "🎉 Done! Your Android environment is ready."
echo ""
