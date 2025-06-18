import SwiftUI
import AppKit

@main
struct WallpaperChangerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isShowingMainWindow = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { _ in
                    // Don't quit when window closes, just hide it
                    isShowingMainWindow = false
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var wallpaperManager: WallpaperManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "photo", accessibilityDescription: "Wallpaper Changer")
            button.action = #selector(statusItemClicked)
            button.target = self
        }
        
        // Create menu
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show Wallpaper Changer", action: #selector(showMainWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Stop Video Wallpaper", action: #selector(stopVideoWallpaper), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
        
        // Don't quit when all windows are closed
        NSApp.setActivationPolicy(.accessory)
    }
    
    @objc func statusItemClicked() {
        // Toggle menu
    }
    
    @objc func showMainWindow() {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        
        // Show the main window
        for window in NSApp.windows {
            if window.contentViewController is NSHostingController<ContentView> {
                window.makeKeyAndOrderFront(nil)
                return
            }
        }
    }
    
    @objc func stopVideoWallpaper() {
        // Get the wallpaper manager and stop video
        if let wallpaperManager = wallpaperManager {
            wallpaperManager.stopVideoWallpaper()
        }
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Don't quit when window closes, just hide the app
        NSApp.setActivationPolicy(.accessory)
        return false
    }
} 