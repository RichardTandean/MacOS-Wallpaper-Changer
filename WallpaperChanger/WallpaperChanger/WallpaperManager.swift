import Foundation
import AppKit
import SwiftUI
import AVFoundation

class WallpaperManager: ObservableObject {
    @Published var currentWallpapers: [URL] = []
    @Published var statusMessage: String?
    @Published var isVideoWallpaperActive = false
    
    private let workspace = NSWorkspace.shared
    private var videoWindows: [VideoWallpaperWindow] = []
    
    init() {
        refreshCurrentWallpapers()
    }
    
    func refreshCurrentWallpapers() {
        currentWallpapers.removeAll()
        
        for screen in NSScreen.screens {
            if let imageURL = workspace.desktopImageURL(for: screen) {
                currentWallpapers.append(imageURL)
            }
        }
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func setWallpaper(_ imageURL: URL, for screen: NSScreen? = nil) {
        do {
            if let targetScreen = screen {
                // Set wallpaper for specific screen
                try setWallpaperForScreen(imageURL, screen: targetScreen)
            } else {
                // Set wallpaper for all screens
                for screen in NSScreen.screens {
                    try setWallpaperForScreen(imageURL, screen: screen)
                }
            }
            
            DispatchQueue.main.async {
                self.statusMessage = "Wallpaper set successfully!"
                self.refreshCurrentWallpapers()
                
                // Clear status message after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.statusMessage = nil
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                self.statusMessage = "Error setting wallpaper: \(error.localizedDescription)"
                
                // Clear error message after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.statusMessage = nil
                }
            }
        }
    }
    
    private func setWallpaperForScreen(_ imageURL: URL, screen: NSScreen) throws {
        // Check if the file exists
        guard FileManager.default.fileExists(atPath: imageURL.path) else {
            throw WallpaperError.fileNotFound
        }
        
        // Check if it's an image file
        guard isImageFile(imageURL) else {
            throw WallpaperError.unsupportedFileType
        }
        
        // Handle different types of wallpapers
        if isDynamicWallpaper(imageURL) {
            try setDynamicWallpaper(imageURL, for: screen)
        } else if isVideoFile(imageURL) {
            try setVideoWallpaper(imageURL, for: screen)
        } else {
            try setStaticWallpaper(imageURL, for: screen)
        }
    }
    
    private func setStaticWallpaper(_ imageURL: URL, for screen: NSScreen) throws {
        var options: [NSWorkspace.DesktopImageOptionKey: Any] = [:]
        
        // Set scaling options
        options[.imageScaling] = NSImageScaling.scaleProportionallyUpOrDown.rawValue
        options[.allowClipping] = true
        
        try workspace.setDesktopImageURL(imageURL, for: screen, options: options)
    }
    
    private func setDynamicWallpaper(_ imageURL: URL, for screen: NSScreen) throws {
        // Dynamic wallpapers are handled automatically by macOS
        // We just need to set them like regular images
        try setStaticWallpaper(imageURL, for: screen)
    }
    
    private func setVideoWallpaper(_ videoURL: URL, for screen: NSScreen) throws {
        // Stop any existing video wallpapers
        stopVideoWallpaper()
        
        // Create video window for the specific screen
        let videoWindow = VideoWallpaperWindow(for: screen)
        videoWindow.orderFront(nil)
        videoWindow.orderBack(nil)
        
        // Start accessing the security-scoped resource
        let accessing = videoURL.startAccessingSecurityScopedResource()
        videoWindow.playVideo(url: videoURL)
        if accessing {
            videoURL.stopAccessingSecurityScopedResource()
        }
        
        videoWindows.append(videoWindow)
        
        DispatchQueue.main.async {
            self.isVideoWallpaperActive = true
        }
    }
    
    // MARK: - Utility Methods
    
    private func isImageFile(_ url: URL) -> Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "tiff", "tif", "gif", "bmp", "heic", "heif", "webp"]
        let fileExtension = url.pathExtension.lowercased()
        return imageExtensions.contains(fileExtension)
    }
    
    private func isDynamicWallpaper(_ url: URL) -> Bool {
        let dynamicExtensions = ["heic"]
        let fileExtension = url.pathExtension.lowercased()
        return dynamicExtensions.contains(fileExtension)
    }
    
    func isVideoFile(_ url: URL) -> Bool {
        let videoExtensions = ["mp4", "mov", "avi", "mkv", "webm"]
        let fileExtension = url.pathExtension.lowercased()
        return videoExtensions.contains(fileExtension)
    }
    
    // MARK: - Screen Management
    
    func getScreens() -> [NSScreen] {
        return NSScreen.screens
    }
    
    func getScreenName(_ screen: NSScreen) -> String {
        let name = screen.localizedName
        if !name.isEmpty {
            return name
        } else if screen == NSScreen.main {
            return "Main Display"
        } else {
            return "Display \(NSScreen.screens.firstIndex(of: screen) ?? 0 + 1)"
        }
    }
    
    // MARK: - Wallpaper Collections
    
    func getSystemWallpapers() -> [URL] {
        var wallpapers: [URL] = []
        
        // System wallpaper directories
        let systemPaths = [
            "/System/Library/Desktop Pictures",
            "/Library/Desktop Pictures"
        ]
        
        for path in systemPaths {
            let url = URL(fileURLWithPath: path)
            if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) {
                for case let fileURL as URL in enumerator {
                    if isImageFile(fileURL) {
                        wallpapers.append(fileURL)
                    }
                }
            }
        }
        
        return wallpapers
    }
    
    // MARK: - Video Wallpaper Management
    
    func setVideoWallpaperOnAllScreens(_ videoURL: URL) {
        do {
            stopVideoWallpaper()
            
            for screen in NSScreen.screens {
                let videoWindow = VideoWallpaperWindow(for: screen)
                videoWindow.orderFront(nil)
                videoWindow.orderBack(nil)
                
                // Start accessing the security-scoped resource
                let accessing = videoURL.startAccessingSecurityScopedResource()
                videoWindow.playVideo(url: videoURL)
                if accessing {
                    videoURL.stopAccessingSecurityScopedResource()
                }
                
                videoWindows.append(videoWindow)
            }
            
            DispatchQueue.main.async {
                self.isVideoWallpaperActive = true
                self.statusMessage = "Video wallpaper set successfully!"
                
                // Clear status message after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.statusMessage = nil
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                self.statusMessage = "Error setting video wallpaper: \(error.localizedDescription)"
                
                // Clear error message after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.statusMessage = nil
                }
            }
        }
    }
    
    func stopVideoWallpaper() {
        for window in videoWindows {
            window.stopVideo()
            window.close()
        }
        videoWindows.removeAll()
        
        DispatchQueue.main.async {
            self.isVideoWallpaperActive = false
        }
    }
    

}

// MARK: - Errors

enum WallpaperError: LocalizedError {
    case fileNotFound
    case unsupportedFileType
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "The selected file could not be found."
        case .unsupportedFileType:
            return "The selected file type is not supported."
        case .permissionDenied:
            return "Permission denied. Please grant necessary permissions in System Preferences."
        }
    }
} 