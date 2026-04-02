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
    echo "export PATH=\"/usr/local/opt/openjdk@17/bin:\$PATH\"" >> ~/.zshrc
    export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
else
    echo "✅ Java already installed"
fi

# Install Android SDK
if ! command -v sdkmanager &> /dev/null; then
    echo "Installing Android SDK..."
    brew install android-sdk
else
    echo "✅ Android SDK already installed"
fi

# Install Android Platform Tools (adb, emulator, etc.)
if ! command -v adb &> /dev/null; then
    echo "Installing Android Platform Tools..."
    brew install android-platform-tools
else
    echo "✅ Android Platform Tools already installed"
fi

# Set Android SDK paths
export ANDROID_SDK_ROOT=$(brew --prefix)/opt/android-sdk
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools/bin"

# Add to shell profile for future sessions
if ! grep -q "ANDROID_SDK_ROOT" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Android SDK Configuration" >> ~/.zshrc
    echo "export ANDROID_SDK_ROOT=\$(brew --prefix)/opt/android-sdk" >> ~/.zshrc
    echo "export PATH=\"\$PATH:\$ANDROID_SDK_ROOT/platform-tools:\$ANDROID_SDK_ROOT/tools/bin\"" >> ~/.zshrc
fi

echo ""
echo "📱 Setting up Android Emulator..."
echo ""

# Accept Android licenses
echo "Accepting Android licenses (this may take a moment)..."
yes | sdkmanager --licenses > /dev/null 2>&1 || true

# Install Android 34 system image
echo "Downloading Android 34 system image (this may take 5-10 minutes)..."
sdkmanager "system-images;android-34;google_apis;arm64-v8a" "emulator" "platform-tools" "platforms;android-34"

# Create emulator
echo ""
echo "Creating virtual device 'CurrencyApp'..."
avdmanager delete avd -n CurrencyApp 2>/dev/null || true
echo "no" | avdmanager create avd -n CurrencyApp -k "system-images;android-34;google_apis;arm64-v8a" -d "Pixel 6"

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
