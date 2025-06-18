import AppKit
import AVFoundation
import AVKit

class VideoWallpaperWindow: NSWindow {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoURL: URL?
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        setupWindow()
    }
    
    convenience init(for screen: NSScreen) {
        self.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override to prevent window from becoming key or main
    override var canBecomeKey: Bool {
        return false
    }
    
    override var canBecomeMain: Bool {
        return false
    }
    
    private func setupWindow() {
        // Configure window to appear as desktop wallpaper
        // Use a level just above the desktop but below everything else
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)) + 1)
        isOpaque = true
        backgroundColor = .black
        ignoresMouseEvents = true
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        
        // Window configuration
        isMovable = false
        isReleasedWhenClosed = false
        hidesOnDeactivate = false
        
        // Create content view
        let contentView = NSView()
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.black.cgColor
        self.contentView = contentView
        
        // Make sure the window is visible
        setIsVisible(true)
    }
    
    func playVideo(url: URL) {
        stopVideo() // Stop any existing video
        
        videoURL = url
        print("VideoWallpaperWindow: Starting video playback for \(url.lastPathComponent)")
        
        // Check if file exists and is accessible
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("VideoWallpaperWindow: Video file does not exist at path: \(url.path)")
            return
        }
        
        // Create player
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Create player layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        
        // Set the frame to match the content view bounds (not window frame)
        if let contentView = contentView, let playerLayer = playerLayer {
            playerLayer.frame = contentView.bounds
            contentView.layer?.addSublayer(playerLayer)
            print("VideoWallpaperWindow: Added player layer with frame: \(playerLayer.frame)")
        }
        
        // Setup looping
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinish),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Mute the video (wallpapers shouldn't make sound)
        player?.isMuted = true
        
        // Add observer for player status
        player?.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        
        // Start playing immediately
        DispatchQueue.main.async {
            self.player?.play()
            print("VideoWallpaperWindow: Started video playback")
        }
    }
    
    @objc private func playerDidFinish() {
        // Loop the video
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let player = object as? AVPlayer {
                switch player.status {
                case .readyToPlay:
                    print("VideoWallpaperWindow: Player ready to play")
                    DispatchQueue.main.async {
                        player.play()
                        print("VideoWallpaperWindow: Player started successfully")
                    }
                case .failed:
                    print("VideoWallpaperWindow: Player failed: \(player.error?.localizedDescription ?? "Unknown error")")
                case .unknown:
                    print("VideoWallpaperWindow: Player status unknown")
                @unknown default:
                    print("VideoWallpaperWindow: Player status unknown case")
                }
            }
        }
    }
    
    func stopVideo() {
        // Remove observer
        if let player = player {
            player.removeObserver(self, forKeyPath: "status")
        }
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setFrame(_ frameRect: NSRect, display flag: Bool) {
        super.setFrame(frameRect, display: flag)
        // Update content view and player layer frames
        contentView?.frame = NSRect(x: 0, y: 0, width: frameRect.width, height: frameRect.height)
        playerLayer?.frame = contentView?.bounds ?? NSRect(x: 0, y: 0, width: frameRect.width, height: frameRect.height)
    }
    
    deinit {
        stopVideo()
    }
} 