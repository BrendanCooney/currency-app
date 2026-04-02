# API Configuration Guide

## Getting Your Free API Key

### Step 1: Sign Up for Free Tier

1. Navigate to [exchangerate-api.com](https://www.exchangerate-api.com)
2. Click "Get Free Key" or "Sign Up"
3. Create an account (email verification required)
4. Confirm your email address

### Step 2: Retrieve Your API Key

After login, your API key will be displayed on the dashboard. It looks like:
```
abc123def456ghi789jkl012mno345pqr
```

### Step 3: Configure in Android App

#### Option A: BuildConfig (Recommended for Play Store)

1. Edit `app/build.gradle.kts`

2. Add to `buildTypes`:
```kotlin
buildTypes {
    debug {
        buildConfigField("String", "EXCHANGE_API_KEY", "\"YOUR_FREE_API_KEY\"")
    }
    release {
        buildConfigField("String", "EXCHANGE_API_KEY", "\"YOUR_RELEASE_API_KEY\"")
        isMinifyEnabled = true
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
}
```

3. Update `ExchangeRateApi.kt`:
```kotlin
@GET("v6/${BuildConfig.EXCHANGE_API_KEY}/latest/{baseCode}")
suspend fun getExchangeRates(
    @Path("baseCode") baseCode: String
): ExchangeRateResponse
```

4. Sync Gradle and rebuild

#### Option B: Dynamic Configuration (For Development)

1. Create a file `app/src/main/java/com/brendan/currencyapp/config/ApiConfig.kt`:

```kotlin
package com.brendan.currencyapp.config

object ApiConfig {
    // Replace with your key from exchangerate-api.com
    const val API_KEY = "YOUR_API_KEY_HERE"
}
```

2. Update `ExchangeRateApi.kt`:
```kotlin
@GET("v6/{apiKey}/latest/{baseCode}")
suspend fun getExchangeRates(
    @Path("apiKey") apiKey: String = ApiConfig.API_KEY,
    @Path("baseCode") baseCode: String
): ExchangeRateResponse
```

### Step 4: Test the Connection

Run the app in debug mode. In Logcat, you should see:
```
ExchangeRateApi: Response successful for base currency: USD
```

If you see errors like "API request failed" or "Unauthorized", verify:
- API key is correct (copy-paste from dashboard)
- Internet connection is enabled
- Request limit not exceeded (free tier: 1500/month)

## Free Tier Limits

- **1,500 requests/month** (about 50/day)
- **USD base currency** (can convert TO any currency)
- **Supported currencies**: 160+
- **Update frequency**: Live (updated ~every 6 hours)

## Common Issues

### "403 Forbidden" Error
- Invalid API key
- API key has been regenerated in dashboard
- Account not verified (check email)

### "429 Too Many Requests"
- Exceeded monthly free tier limit
- Upgrade to paid plan or wait until next month

### "Invalid currency code"
- Using unsupported currency (only 5 supported in this app)
- Check `CurrencyViewModel.kt` for supported list

## Upgrading to Paid Plan

For production apps with higher request limits:

1. Log in to exchangerate-api.com
2. Visit Plans & Pricing
3. Choose paid tier (from $5-50/month)
4. Same API key format, but with higher limits

## For Production/Play Store

**NEVER commit your API key to version control!**

Use BuildConfig with environment variables or GitHub Secrets:

```yaml
# .github/workflows/build.yml
env:
  EXCHANGE_API_KEY: ${{ secrets.EXCHANGE_API_KEY }}
```

When building for release:
```bash
EXCHANGE_API_KEY="your-production-key" ./gradlew bundleRelease
```

---

Questions? Check the [API documentation](https://www.exchangerate-api.com/docs)
