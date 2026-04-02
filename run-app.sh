#!/bin/bash

# Currency App - Quick Launch Script
# Starts emulator and installs/runs the app

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Currency App - Quick Launch"
echo "=============================="
echo ""

# Check if emulator is already running
if adb devices | grep -q "CurrencyApp"; then
    echo "✅ Emulator already running"
else
    echo "📱 Starting emulator..."
    echo "   (This will open a new window and take 30-60 seconds)"
    emulator -avd CurrencyApp &
    EMULATOR_PID=$!
    
    echo "⏳ Waiting for emulator to boot..."
    sleep 45
    
    # Wait for device to be ready
    while ! adb shell getprop sys.boot_completed 2>/dev/null | grep -q "1"; do
        echo "⏳ Still waiting for emulator..."
        sleep 5
    done
    
    echo "✅ Emulator ready"
fi

echo ""
echo "🏗️  Building and installing app..."
cd "$SCRIPT_DIR"
./gradlew installDebug

echo ""
echo "🎯 Launching app..."
sleep 2
adb shell am start -n com.brendan.currencyapp/com.brendan.currencyapp.ui.MainActivity

echo ""
echo "✅ App launched!"
echo ""
echo "💡 Tips:"
echo "   - App is running on your emulator"
echo "   - Keep this terminal open to see logs"
echo "   - Press Ctrl+C to stop"
echo "   - Check app by tapping icons in emulator"
echo ""
