#!/bin/bash

# WallpaperChanger DMG Build Script
# Run this from the project root directory

APP_NAME="WallpaperChanger"
VERSION="1.0"
DMG_NAME="${APP_NAME}-${VERSION}"
BUILD_DIR="build"
DMG_DIR="dmg_temp"

echo "🚀 Building WallpaperChanger DMG..."

# Clean previous builds
rm -rf "${BUILD_DIR}"
rm -rf "${DMG_DIR}"
rm -f "${DMG_NAME}.dmg"

# Build the app for release
echo "📱 Building app..."
xcodebuild -project WallpaperChanger.xcodeproj \
           -scheme WallpaperChanger \
           -configuration Release \
           -derivedDataPath "${BUILD_DIR}" \
           clean build

# Check if build succeeded
if [ ! -d "${BUILD_DIR}/Build/Products/Release/${APP_NAME}.app" ]; then
    echo "❌ Build failed! App not found."
    exit 1
fi

echo "✅ Build successful!"

# Create DMG staging directory
mkdir -p "${DMG_DIR}"

# Copy app to staging directory
cp -R "${BUILD_DIR}/Build/Products/Release/${APP_NAME}.app" "${DMG_DIR}/"

# Create Applications symlink
ln -s /Applications "${DMG_DIR}/Applications"

# Create DMG
echo "📦 Creating DMG..."
hdiutil create -volname "${APP_NAME}" \
               -srcfolder "${DMG_DIR}" \
               -ov \
               -format UDZO \
               "${DMG_NAME}.dmg"

# Clean up
rm -rf "${BUILD_DIR}"
rm -rf "${DMG_DIR}"

echo "🎉 DMG created successfully: ${DMG_NAME}.dmg"
echo "📍 Location: $(pwd)/${DMG_NAME}.dmg"

# Make script executable
chmod +x build_dmg.sh

# Build DMG automatically
./build_dmg.sh 