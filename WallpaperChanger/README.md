# 🎬 WallpaperChanger for macOS

A modern macOS application built with SwiftUI that allows you to easily change your desktop wallpaper, including support for **live video wallpapers**.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- 🎬 **Live Video Wallpapers** - Set MP4, MOV videos as animated wallpapers
- 🖼️ **Static Image Support** - JPG, PNG, TIFF, GIF, BMP, HEIC, WebP
- 🌅 **Dynamic Wallpapers** - macOS HEIC dynamic wallpapers that change with time
- 🔄 **Auto-Change Mode** - Slideshow with custom intervals (5-300 seconds)
- 🖥️ **Multi-Screen Support** - Works across multiple displays
- 📱 **Menu Bar Integration** - Background operation with persistent video wallpapers
- 🎲 **Random Selection** - Smart wallpaper randomization
- 👁️ **Live Preview** - Thumbnail previews of current and selected wallpapers

## 🎯 What Makes This Special

Unlike other wallpaper apps, **WallpaperChanger supports true video wallpapers** that:
- ✅ **Persist when app is closed** - Videos keep playing in background
- ✅ **Run smoothly** - Optimized video rendering at desktop level
- ✅ **Auto-loop seamlessly** - Perfect continuous playback
- ✅ **Silent operation** - Videos play muted (appropriate for wallpapers)

## 📱 Screenshots

*// Add screenshots here when ready*

## 🔧 Requirements

- **macOS 13.0** or later
- **Xcode 15.0** or later (for building from source)
- **Apple Silicon or Intel Mac**

## 🚀 Installation

### Option 1: Download Release
1. Go to [Releases](../../releases)
2. Download the latest `WallpaperChanger.dmg`
3. Open DMG and drag app to Applications folder

### Option 2: Build from Source
```bash
git clone https://github.com/your-username/WallpaperChanger.git
cd WallpaperChanger
open WallpaperChanger.xcodeproj
```
Build and run in Xcode (⌘+R)

## 🎬 Usage

### Basic Wallpaper Management
1. **Launch WallpaperChanger**
2. **Click "Select Images"** to choose wallpaper files
3. **Choose your action:**
   - **Set Current Image** - Apply selected wallpaper
   - **Set Random** - Apply random wallpaper from selection
   - **Next Image** - Cycle to next wallpaper

### Video Wallpapers
1. **Select MP4/MOV files** using the file picker
2. **Video files show with play icon** in the preview
3. **Click any "Set" button** - App automatically detects and plays video
4. **Close app window** - Video continues playing from menu bar
5. **Control from menu bar** - Stop video or reopen window anytime

### Auto-Change Slideshow
1. **Toggle "Auto-change wallpaper"**
2. **Set interval** with slider (5-300 seconds)
3. **Mix images and videos** - App handles both seamlessly

### Menu Bar Operation
- 🖼️ **Show Window** - Reopen main interface
- ⏹️ **Stop Video** - Stop video wallpaper
- 🚪 **Quit** - Exit application

## 🎯 Supported Formats

| Type | Formats |
|------|---------|
| **Video** | MP4, MOV, AVI, MKV, WebM |
| **Images** | JPG, JPEG, PNG, TIFF, TIF, GIF, BMP, WebP |
| **Dynamic** | HEIC, HEIF (macOS dynamic wallpapers) |

## 🔨 Building

### Quick Build
```bash
# Clone repository
git clone https://github.com/your-username/WallpaperChanger.git
cd WallpaperChanger

# Open in Xcode
open WallpaperChanger.xcodeproj

# Build and run
# Press ⌘+R in Xcode
```

### Create DMG Distribution
```bash
# Make build script executable
chmod +x build_dmg.sh

# Build DMG automatically
./build_dmg.sh

# Find your DMG
ls -la WallpaperChanger-*.dmg
```

## 🏗️ Architecture

### Core Components
- **WallpaperChangerApp** - Main app entry point with menu bar integration
- **ContentView** - SwiftUI interface with modern design
- **WallpaperManager** - Core wallpaper management logic
- **VideoWallpaperWindow** - Custom NSWindow for video rendering

### Key Technologies
- **SwiftUI** - Modern, native macOS interface
- **AppKit** - Native macOS window management
- **AVFoundation** - Video playback and rendering
- **Sandboxing** - Secure file access with proper entitlements

## 🤝 Contributing

1. **Fork the repository**
2. **Create feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit changes** (`git commit -m 'Add amazing feature'`)
4. **Push to branch** (`git push origin feature/amazing-feature`)
5. **Open Pull Request**

### Development Setup
```bash
git clone https://github.com/your-username/WallpaperChanger.git
cd WallpaperChanger
open WallpaperChanger.xcodeproj
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with **SwiftUI** and **AppKit**
- Uses **AVFoundation** for video playback
- Inspired by the need for native macOS video wallpapers
- Thanks to the macOS developer community

## 🐛 Issues & Support

- **Found a bug?** [Open an issue](../../issues)
- **Feature request?** [Start a discussion](../../discussions)
- **Need help?** Check the [wiki](../../wiki) or open an issue

## 📊 Project Stats

![GitHub stars](https://img.shields.io/github/stars/your-username/WallpaperChanger)
![GitHub forks](https://img.shields.io/github/forks/your-username/WallpaperChanger)
![GitHub issues](https://img.shields.io/github/issues/your-username/WallpaperChanger)

---

**Made with ❤️ for the macOS community**

*Transform your desktop with beautiful video wallpapers that actually work!* 🎬✨ 