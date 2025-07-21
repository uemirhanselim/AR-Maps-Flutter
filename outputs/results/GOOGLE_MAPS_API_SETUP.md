# Google Maps API Setup Guide

## Issue
The app is throwing an error because the Google Maps API key is missing:
```
java.lang.IllegalStateException: API key not found. Check that <meta-data android:name="com.google.android.geo.API_KEY" android:value="your API key"/> is in the <application> element of AndroidManifest.xml
```

## Solution

### Step 1: Get a Google Maps API Key

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Places API (for POI functionality)
   - Geocoding API (for address conversion)

### Step 2: Create API Key

1. In the Google Cloud Console, go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "API Key"
3. Copy the generated API key

### Step 3: Update AndroidManifest.xml

Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` in the file:
```
android/app/src/main/AndroidManifest.xml
```

With your actual API key:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyYourActualApiKeyHere" />
```

### Step 4: Restrict API Key (Recommended)

1. In Google Cloud Console, click on your API key
2. Under "Application restrictions", select "Android apps"
3. Add your app's package name: `com.example.ar_navigation_flutter`
4. Add your app's SHA-1 certificate fingerprint
5. Under "API restrictions", select "Restrict key" and choose the APIs you enabled

### Step 5: Test the App

After adding the API key, rebuild and run the app:
```bash
flutter clean
flutter pub get
flutter run
```

## Alternative: Use a Test API Key

For development purposes, you can use a test API key, but it will have usage limits:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBla" />
```

## Permissions Added

The following permissions have been added to AndroidManifest.xml:
- `ACCESS_FINE_LOCATION` - For precise location
- `ACCESS_COARSE_LOCATION` - For approximate location
- `CAMERA` - For AR functionality
- `INTERNET` - For API calls
- `ACCESS_NETWORK_STATE` - For network status

## AR Core Feature

The app also requires AR Core support:
```xml
<uses-feature android:name="android.hardware.camera.ar" android:required="true" />
```

This means the app will only install on devices that support AR Core. 