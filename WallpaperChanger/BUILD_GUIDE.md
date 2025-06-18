# 📦 WallpaperChanger Build & Distribution Guide

## 🎯 What's Fixed

### **Background App Support**
- ✅ **App stays running when window closed** - Video wallpapers persist
- ✅ **Menu bar integration** - Control app from menu bar
- ✅ **Background operation** - No dock icon when window closed
- ✅ **Quick access** - Reopen window from menu bar

### **Menu Bar Features**
- 🖼️ **Show Wallpaper Changer** - Reopen main window
- ⏹️ **Stop Video Wallpaper** - Stop video without opening window
- 🚪 **Quit** - Completely exit the app

---

## 🔨 Building DMG (3 Methods)

### **Method 1: Automatic Script (Recommended)**

1. **Make script executable:**
   ```bash
   chmod +x build_dmg.sh
   ```

2. **Run the script:**
   ```bash
   ./build_dmg.sh
   ```

3. **Find your DMG:**
   - Location: `WallpaperChanger-1.0.dmg`
   - Ready for distribution! 🎉

---

### **Method 2: Xcode Archive (Manual)**

1. **Open Xcode project**
2. **Select "Any Mac" as destination**
3. **Product → Archive** (⌘+⇧+B)
4. **Organizer opens → Distribute App**
5. **Choose "Copy App"**
6. **Select destination folder**

**Create DMG manually:**
```bash
# Navigate to your exported app
hdiutil create -volname "WallpaperChanger" \
               -srcfolder . \
               -ov \
               -format UDZO \
               WallpaperChanger.dmg
```

---

### **Method 3: Command Line Build**

```bash
# Build for release
xcodebuild -project WallpaperChanger.xcodeproj \
           -scheme WallpaperChanger \
           -configuration Release \
           clean build

# Find built app
find . -name "WallpaperChanger.app" -type d

# Create DMG
mkdir dmg_contents
cp -R path/to/WallpaperChanger.app dmg_contents/
ln -s /Applications dmg_contents/Applications

hdiutil create -volname "WallpaperChanger" \
               -srcfolder dmg_contents \
               -ov \
               -format UDZO \
               WallpaperChanger.dmg
```

---

## 🚀 App Usage After Build

### **Installing the App**
1. **Open DMG** - Double-click `WallpaperChanger-1.0.dmg`
2. **Drag to Applications** - Drag app to Applications folder
3. **Launch** - Open from Applications or Launchpad

### **Using Background Mode**
1. **Set video wallpaper** - Choose MP4 and set as wallpaper
2. **Close window** - App continues running in menu bar
3. **Video persists** - Wallpaper keeps playing
4. **Menu bar control** - Click menu bar icon for controls

### **Permissions Required**
- **File Access** - To read wallpaper files
- **Security & Privacy** - May need approval for video wallpapers

---

## 🎬 Video Wallpaper Persistence

### **What happens now:**
- ✅ **Window closes** → App stays in menu bar
- ✅ **Video continues** → Wallpaper keeps playing  
- ✅ **System restart** → Need to restart app manually
- ✅ **Menu access** → Control without opening window

### **Supported formats:**
- **Videos**: MP4, MOV, AVI, MKV, WebM
- **Images**: JPG, PNG, TIFF, GIF, BMP, HEIC, HEIF, WebP
- **Dynamic**: macOS HEIC dynamic wallpapers

---

## 🔧 Distribution Tips

### **Code Signing (Optional)**
```bash
# Sign the app for distribution
codesign --force --deep --sign "Developer ID Application: Your Name" WallpaperChanger.app

# Verify signing
codesign --verify --verbose WallpaperChanger.app
```

### **Notarization (For Mac App Store)**
- Required for distribution outside App Store
- Needs Apple Developer account
- Use Xcode's built-in notarization

### **DMG Customization**
- Add custom background image
- Custom icon positioning
- License agreement
- Use tools like DMG Canvas for advanced customization

---

## 🎯 Summary

**What you get:**
- 📱 **Standalone app** - No dependencies
- 🎬 **Persistent video wallpapers** - Survive window closing
- 📦 **DMG installer** - Professional distribution
- 🔧 **Menu bar controls** - Background operation
- 🚀 **Ready to share** - Complete installation package

Your DMG will contain everything users need to install and use WallpaperChanger with full video wallpaper support! 🎉 