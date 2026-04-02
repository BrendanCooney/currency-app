# Currency Converter App

A modern Android currency converter app built with Kotlin, Jetpack Compose, and real-time exchange rate API integration.

## Features

- 🔄 **Real-time Exchange Rates** - Live rates for USD, GBP, EUR, ZAR, and BTC
- 💱 **Instant Conversion** - Calculate conversions between any supported currencies
- 📈 **Rate Display** - View all current exchange rates at a glance
- 🔄 **Pull to Refresh** - Manually update rates anytime
- 💾 **Offline Support** - Rates cached locally for offline access
- 🌙 **Dark Mode** - Automatic dark/light theme support
- ⚡ **Fast & Responsive** - Built with modern Android architecture
- 🔐 **Production-ready** - ProGuard obfuscation and optimized

## Architecture

The app follows modern Android best practices:

- **MVVM Pattern** - ViewModel manages UI state
- **Repository Pattern** - Centralized data access
- **Dependency Injection** - Hilt for clean dependency management
- **Jetpack Compose** - Modern declarative UI
- **Room Database** - Local data persistence
- **Retrofit** - Type-safe HTTP client
- **Coroutines** - Async operations
- **StateFlow** - Reactive state management

## Setup Instructions

### Prerequisites

- Android Studio Flamingo or later
- Android SDK 26+
- Kotlin 1.9.0+
- Java 17+

### 1. Clone and Setup

```bash
git clone <repository-url>
cd currency-app
```

### 2. Get API Key

1. Visit [exchangerate-api.com](https://www.exchangerate-api.com)
2. Sign up for a free account
3. Copy your API key

### 3. Configure API Key

Open `app/src/main/java/com/brendan/currencyapp/data/remote/ExchangeRateApi.kt` and replace:

```kotlin
const val BASE_URL = "https://v6.exchangerate-api.com/"
```

With your API URL including your key:

```kotlin
// In the @GET endpoint
@GET("v6/YOUR_API_KEY/latest/{baseCode}")
```

**Security Note**: For production/Play Store submission, store the API key securely:

```kotlin
// Better approach - use BuildConfig
@GET("v6/${BuildConfig.EXCHANGE_API_KEY}/latest/{baseCode}")
```

Add to `app/build.gradle.kts`:
```kotlin
buildTypes {
    release {
        buildConfigField("String", "EXCHANGE_API_KEY", "\"YOUR_KEY_HERE\"")
    }
}
```

### 4. Build the App

```bash
# Debug build
./gradlew assembleDebug

# Release build (optimized for Play Store)
./gradlew assembleRelease
```

### 5. Run on Emulator/Device

```bash
./gradlew installDebug
```

## Building for Google Play Store

### Step 1: Create Signing Key

```bash
keytool -genkey -v -keystore currency-app.jks -keyalg RSA -keysize 2048 -validity 10000 -alias currency-app
```

### Step 2: Configure Signing in Gradle

Create `keystore.properties` in project root:

```properties
storeFile=currency-app.jks
storePassword=YOUR_PASSWORD
keyAlias=currency-app
keyPassword=YOUR_PASSWORD
```

Update `app/build.gradle.kts`:

```kotlin
signingConfigs {
    create("release") {
        val keystoreFile = rootProject.file("keystore.properties")
        val properties = Properties()
        if (keystoreFile.exists()) {
            properties.load(keystoreFile.inputStream())
        }
        storeFile = file(properties["storeFile"] ?: "")
        storePassword = properties["storePassword"] as? String
        keyAlias = properties["keyAlias"] as? String
        keyPassword = properties["keyPassword"] as? String
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
}
```

### Step 3: Generate Release APK/Bundle

```bash
# Generate AAB (recommended for Play Store)
./gradlew bundleRelease

# Or generate APK
./gradlew assembleRelease
```

### Step 4: Submit to Google Play

1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app
3. Fill in app details (title, description, screenshots, etc.)
4. Upload the signed AAB/APK
5. Complete store listing information
6. Request review

## Configuration

### Supported Currencies

Edit `CurrencyViewModel.kt`:

```kotlin
private val supportedCurrencies = listOf("USD", "GBP", "EUR", "ZAR", "BTC")
```

### Cache Duration

Default cache is 1 hour. Edit in `ExchangeRateRepository.kt`:

```kotlin
if (cached != null && (now - cached.timestamp) < 60 * 60 * 1000) {
    // Use cache
}
```

### Theme Colors

Customize in `MainActivity.kt` - `LightColorScheme` and `DarkColorScheme` objects.

## Project Structure

```
app/src/
├── main/
│   ├── java/com/brendan/currencyapp/
│   │   ├── data/
│   │   │   ├── local/          # Room database, entities, DAOs
│   │   │   ├── remote/         # Retrofit API, models
│   │   │   └── repository/     # Data access logic
│   │   ├── di/                 # Hilt dependency injection
│   │   ├── ui/
│   │   │   ├── screens/        # Compose UI screens
│   │   │   ├── viewmodel/      # MVVM ViewModels
│   │   │   └── MainActivity.kt
│   ├── res/
│   │   ├── values/             # Strings, colors, themes
│   │   └── drawable/           # Icons, images
│   └── AndroidManifest.xml
└── test/                        # Unit tests
```

## Development

### Run Tests

```bash
./gradlew test
./gradlew connectedAndroidTest
```

### Generate AndroidStudio Project Files

```bash
./gradlew androidStudio
```

## Dependencies Overview

- **Jetpack Compose** - Modern UI framework
- **Retrofit 2** - REST API client
- **Room** - Local database
- **Hilt** - Dependency injection
- **OkHttp** - HTTP client
- **Gson** - JSON serialization
- **Coroutines** - Async programming
- **Material3** - Material Design 3 components

## Troubleshooting

### API Key Issues
- Ensure you've replaced the placeholder with your actual API key
- Check exchangerate-api.com API limits (free tier: 1500 requests/month)

### Build Errors
- Run `./gradlew clean` before rebuilding
- Update Android Studio to latest version
- Ensure Java 17+ is installed

### App Crashes
- Check Logcat output: `adb logcat | grep "currencyapp"`
- Verify API key is valid
- Check internet connectivity

## Publishing Checklist

- [ ] API key configured and working
- [ ] All strings localized (if targeting multiple languages)
- [ ] App screenshots prepared (Play Store requires 2-8)
- [ ] Privacy policy URL ready
- [ ] Feature graphic (1024x500px) created
- [ ] Icon finalized (512x512px)
- [ ] Version code/name updated
- [ ] minSdkVersion appropriate for target audience
- [ ] App signed with release key
- [ ] Testing completed (QA, beta testing)
- [ ] Release notes prepared

## Security Considerations

- API key stored in BuildConfig (not hardcoded)
- ProGuard/R8 obfuscation enabled
- HTTPS only for API calls
- No sensitive data stored in SharedPreferences
- Room database not world-readable

## License

This project is provided as-is for your use.

## Support

For issues or questions, contact the development team.

---

**Happy converting!** 💱
