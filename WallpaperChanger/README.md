# WallpaperChanger for macOS

A modern macOS application built with SwiftUI that allows you to easily change your desktop wallpaper, including support for live/dynamic wallpapers.

## Features

- ✨ **Modern SwiftUI Interface** - Clean, native macOS design
- 🖼️ **Multiple Image Support** - Select and manage multiple wallpaper images
- 🔄 **Auto-Change Wallpaper** - Automatically cycle through wallpapers at custom intervals
- 🖥️ **Multi-Screen Support** - Set wallpapers for specific screens or all screens at once
- 🌅 **Dynamic Wallpaper Support** - Supports macOS dynamic wallpapers (HEIC format)
- 📸 **Image Format Support** - JPG, PNG, TIFF, GIF, BMP, HEIC, HEIF, WebP
- 🎲 **Random Selection** - Set a random wallpaper from your collection
- 👁️ **Live Preview** - See thumbnails of current and selected wallpapers

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building from source)

## Installation

### Option 1: Build from Source

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd Learn/WallpaperChanger
   ```

2. Open the project in Xcode:
   ```bash
   open WallpaperChanger.xcodeproj
   ```

3. Build and run the project in Xcode (⌘+R)

### Option 2: Download Release

Download the latest release from the releases page and drag the app to your Applications folder.

## Usage

### Basic Usage

1. **Launch the app** - The WallpaperChanger window will appear
2. **Select Images** - Click "Select Images" to choose wallpaper files from your Mac
3. **Set Wallpaper** - Use the control buttons to set wallpapers:
   - **Set Current Image** - Sets the currently selected image
   - **Set Random** - Sets a random image from your selection
   - **Next Image** - Cycles to the next image in your collection

### Auto-Change Feature

1. **Enable Auto-Change** - Toggle the "Auto-change wallpaper" switch
2. **Set Interval** - Use the slider to set how often wallpapers change (5-300 seconds)
3. **Start Cycling** - The app will automatically cycle through your selected images

### Multi-Screen Support

- The app automatically detects all connected displays
- By default, wallpapers are set on all screens
- Current wallpapers for each screen are displayed at the top of the app

### Supported Image Formats

- **Static Images**: JPG, JPEG, PNG, TIFF, TIF, GIF, BMP, WebP
- **Dynamic Wallpapers**: HEIC, HEIF (macOS dynamic wallpapers)
- **Future Support**: Video wallpapers (MP4, MOV) - coming soon

## Live/Dynamic Wallpapers

### What are Dynamic Wallpapers?

Dynamic wallpapers are special HEIC files that contain multiple images that change automatically based on:
- Time of day
- Light/dark mode settings
- User preferences

### Using Dynamic Wallpapers

1. Download dynamic wallpapers (`.heic` files) from:
   - Apple's official dynamic wallpapers
   - Third-party wallpaper websites
   - Create your own using specialized tools

2. Select the `.heic` file in WallpaperChanger
3. Set it as your wallpaper - macOS will handle the dynamic changes automatically

### Creating Your Own Dynamic Wallpapers

You can create dynamic wallpapers using tools like:
- **Keka** - Can create HEIC files from multiple images
- **Dynamic Wallpaper Club** - Online tool for creating dynamic wallpapers
- **Command line tools** - Using `sips` and other macOS utilities

## Permissions

The app requires the following permissions:
- **File Access** - To read wallpaper image files
- **Pictures Folder** - To access images in your Pictures folder
- **Downloads Folder** - To access downloaded wallpaper files

These permissions are automatically requested when needed.

## Troubleshooting

### Common Issues

**"Permission denied" error**
- Grant the app permission to access files in System Preferences > Privacy & Security

**"File not found" error**
- Ensure the image file hasn't been moved or deleted
- Re-select the images if needed

**Dynamic wallpaper not changing**
- Ensure the file is a proper HEIC dynamic wallpaper
- Check macOS system preferences for dynamic wallpaper settings

**App won't start**
- Ensure you're running macOS 13.0 or later
- Try rebuilding the app if building from source

### Getting Help

If you encounter issues:
1. Check the status message at the bottom of the app window
2. Try selecting different image files
3. Restart the app
4. Check macOS Console for error messages

## Development

### Project Structure

```
WallpaperChanger/
├── WallpaperChanger/
│   ├── WallpaperChangerApp.swift    # Main app entry point
│   ├── ContentView.swift            # Main UI view
│   ├── WallpaperManager.swift       # Core wallpaper functionality
│   ├── Assets.xcassets/             # App icons and colors
│   └── WallpaperChanger.entitlements # App permissions
└── WallpaperChanger.xcodeproj/      # Xcode project file
```

### Key Components

- **WallpaperManager**: Core class handling wallpaper operations
- **ContentView**: SwiftUI view for the main interface
- **Auto-change Timer**: Handles automatic wallpaper cycling
- **Multi-screen Support**: Manages wallpapers across multiple displays

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Built with SwiftUI and AppKit
- Uses NSWorkspace for wallpaper management
- Inspired by the need for a modern, native macOS wallpaper manager

---

**Note**: This app is designed specifically for macOS and takes advantage of native macOS wallpaper management features. For video wallpapers and advanced live wallpaper features, consider using specialized third-party solutions. 