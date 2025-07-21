#!/bin/bash

# Google Maps API Key Setup Script for AR Navigation Flutter App

echo "🚀 Google Maps API Key Setup for AR Navigation Flutter App"
echo "=========================================================="
echo ""

echo "📋 Prerequisites:"
echo "1. Google Cloud Console account"
echo "2. A Google Cloud project"
echo "3. Enabled APIs: Maps SDK for Android, Places API, Geocoding API"
echo ""

echo "🔑 Steps to get your API key:"
echo "1. Go to: https://console.cloud.google.com/apis/credentials"
echo "2. Create a new project or select existing one"
echo "3. Enable required APIs (Maps SDK for Android, Places API, Geocoding API)"
echo "4. Create credentials > API Key"
echo "5. Copy the generated API key"
echo ""

read -p "Enter your Google Maps API key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo "❌ No API key provided. Exiting..."
    exit 1
fi

# Update AndroidManifest.xml
MANIFEST_FILE="android/app/src/main/AndroidManifest.xml"

if [ -f "$MANIFEST_FILE" ]; then
    # Create backup
    cp "$MANIFEST_FILE" "$MANIFEST_FILE.backup"
    
    # Replace the placeholder with actual API key
    sed -i '' "s/YOUR_GOOGLE_MAPS_API_KEY_HERE/$API_KEY/g" "$MANIFEST_FILE"
    
    echo "✅ API key updated in $MANIFEST_FILE"
    echo "📁 Backup created as $MANIFEST_FILE.backup"
else
    echo "❌ AndroidManifest.xml not found at $MANIFEST_FILE"
    exit 1
fi

echo ""
echo "🎉 Setup complete!"
echo "📱 You can now build and run the app:"
echo "   flutter clean"
echo "   flutter pub get"
echo "   flutter run"
echo ""
echo "⚠️  Remember to restrict your API key in Google Cloud Console for security!" 