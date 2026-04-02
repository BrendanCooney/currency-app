# Quick Start Guide

## 5-Minute Setup

### Prerequisites
- Android Studio Flamingo or later
- Java 17+
- Internet connection

### Step 1: Get Free API Key (2 min)

1. Visit: https://www.exchangerate-api.com
2. Click "Get Free Key"
3. Sign up and verify email
4. Copy your API key from dashboard

### Step 2: Configure API Key (1 min)

Edit `app/build.gradle.kts` and add near the end of `android {}`:

```kotlin
buildTypes {
    debug {
        buildConfigField("String", "EXCHANGE_API_KEY", "\"YOUR_API_KEY_HERE\"")
    }
}
```

Replace `YOUR_API_KEY_HERE` with your actual key from Step 1.

### Step 3: Update API Service (1 min)

Edit `app/src/main/java/com/brendan/currencyapp/data/remote/ExchangeRateApi.kt`:

Change line with `@GET`:
```kotlin
@GET("v6/${BuildConfig.EXCHANGE_API_KEY}/latest/{baseCode}")
```

### Step 4: Build & Run (1 min)

In Android Studio:
1. Click **"Sync Now"** when Gradle popup appears
2. Click **"Run"** (green play button) or press Shift+F10
3. Select your emulator/device
4. App launches!

### Step 5: Test Conversion

1. Open the app
2. Enter amount: `100`
3. From: USD, To: GBP
4. Tap **"Convert"**
5. See result! ✅

---

## What You Get

✅ Production-ready Kotlin Android app  
✅ Real-time exchange rates (5 supported currencies)  
✅ Currency conversion calculator  
✅ Offline support (caches rates)  
✅ Dark mode included  
✅ Modern UI with Jetpack Compose  
✅ Ready for Google Play Store  

---

## Project Structure

```
currency-app/
├── app/src/main/java/com/brendan/currencyapp/
│   ├── data/              # Database & API
│   ├── di/                # Dependency injection
│   ├── ui/                # UI screens & views
│   └── MainActivity.kt     # Entry point
├── README.md              # Full documentation
├── API_SETUP.md           # Detailed API setup
└── PLAY_STORE_GUIDE.md    # Google Play submission
```

---

## Common Commands

```bash
# Clean build
./gradlew clean

# Build debug APK
./gradlew assembleDebug

# Build release bundle (for Play Store)
./gradlew bundleRelease

# Run tests
./gradlew test

# Check code quality
./gradlew lint
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **Gradle sync fails** | File → Invalidate Caches → Restart |
| **Emulator won't start** | Tools → Device Manager → Create virtual device |
| **API errors "Unauthorized"** | Check API key is correct in BuildConfig |
| **No internet** | Ensure emulator/device has network access |
| **App crashes** | Check Logcat: Shift+6 (bottom of Android Studio) |

---

## Next Steps

1. **Test thoroughly** on multiple devices/orientations
2. **Add more currencies** in `CurrencyViewModel.kt`
3. **Customize UI** - edit colors in `values/colors.xml`
4. **Submit to Play Store** - follow `PLAY_STORE_GUIDE.md`
5. **Monitor analytics** - add Firebase

---

## Need Help?

- 📖 See `README.md` for full documentation
- 🔑 See `API_SETUP.md` for API configuration
- 🚀 See `PLAY_STORE_GUIDE.md` for Play Store submission
- 💬 Check Logcat for detailed error messages (Shift+6)
- 🔗 Exchange Rate API Docs: https://www.exchangerate-api.com/docs

---

**Ready to launch?** 🎉

The app is production-ready. Just configure your API key and you're set!
