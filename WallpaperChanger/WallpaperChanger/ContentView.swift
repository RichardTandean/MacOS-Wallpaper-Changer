import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var wallpaperManager = WallpaperManager()
    @State private var selectedImages: [URL] = []
    @State private var showingFilePicker = false
    @State private var currentWallpaperIndex = 0
    @State private var autoChange = false
    @State private var changeInterval: Double = 30.0 // seconds
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Wallpaper Changer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // Current wallpaper info
            if !wallpaperManager.currentWallpapers.isEmpty {
                VStack(spacing: 8) {
                    Text("Current Wallpapers")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(wallpaperManager.currentWallpapers.enumerated()), id: \.offset) { index, wallpaper in
                                VStack {
                                    AsyncImage(url: wallpaper) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                    }
                                    .frame(width: 120, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 2)
                                            .opacity(index == currentWallpaperIndex ? 1 : 0)
                                    )
                                    
                                    Text("Screen \(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Selected images
            if !selectedImages.isEmpty {
                VStack(spacing: 8) {
                    Text("Selected Images (\(selectedImages.count))")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, imageURL in
                                VStack {
                                    ZStack {
                                        if wallpaperManager.isVideoFile(imageURL) {
                                            // Video thumbnail placeholder
                                            Rectangle()
                                                .fill(Color.black.opacity(0.8))
                                                .frame(width: 100, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                            
                                            VStack {
                                                Image(systemName: "play.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                Text("MP4")
                                                    .font(.caption2)
                                                    .foregroundColor(.white)
                                            }
                                        } else {
                                            AsyncImage(url: imageURL) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.3))
                                            }
                                            .frame(width: 100, height: 60)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                        }
                                    }
                                    
                                    Text(imageURL.lastPathComponent)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .frame(width: 100)
                                }
                                .contextMenu {
                                    Button("Remove") {
                                        selectedImages.remove(at: index)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Controls
            VStack(spacing: 15) {
                // File selection
                HStack(spacing: 15) {
                    Button("Select Images") {
                        showingFilePicker = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Clear Selection") {
                        selectedImages.removeAll()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(selectedImages.isEmpty)
                }
                
                // Wallpaper actions
                VStack(spacing: 10) {
                    HStack(spacing: 15) {
                        Button("Set Current Image") {
                            if !selectedImages.isEmpty {
                                let currentFile = selectedImages[currentWallpaperIndex % selectedImages.count]
                                if wallpaperManager.isVideoFile(currentFile) {
                                    wallpaperManager.setVideoWallpaperOnAllScreens(currentFile)
                                } else {
                                    wallpaperManager.setWallpaper(currentFile)
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(selectedImages.isEmpty)
                        
                        Button("Set Random") {
                            if !selectedImages.isEmpty {
                                let randomFile = selectedImages.randomElement()!
                                if wallpaperManager.isVideoFile(randomFile) {
                                    wallpaperManager.setVideoWallpaperOnAllScreens(randomFile)
                                } else {
                                    wallpaperManager.setWallpaper(randomFile)
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .disabled(selectedImages.isEmpty)
                        
                        Button("Next Image") {
                            if !selectedImages.isEmpty {
                                currentWallpaperIndex = (currentWallpaperIndex + 1) % selectedImages.count
                                let nextFile = selectedImages[currentWallpaperIndex]
                                if wallpaperManager.isVideoFile(nextFile) {
                                    wallpaperManager.setVideoWallpaperOnAllScreens(nextFile)
                                } else {
                                    wallpaperManager.setWallpaper(nextFile)
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .disabled(selectedImages.isEmpty)
                    }
                    
                    // Video wallpaper controls
                    if wallpaperManager.isVideoWallpaperActive {
                        HStack {
                            Text("🎬 Video wallpaper is active")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Button("Stop Video Wallpaper") {
                                wallpaperManager.stopVideoWallpaper()
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Auto-change settings
                VStack(spacing: 10) {
                    Toggle("Auto-change wallpaper", isOn: $autoChange)
                        .font(.headline)
                        .onChange(of: autoChange) { newValue in
                            if newValue {
                                startAutoChange()
                            } else {
                                stopAutoChange()
                            }
                        }
                    
                    if autoChange {
                        HStack {
                            Text("Change every:")
                            Slider(value: $changeInterval, in: 5...300, step: 5) {
                                Text("Interval")
                            }
                            .onChange(of: changeInterval) { _ in
                                if autoChange {
                                    startAutoChange() // Restart with new interval
                                }
                            }
                            Text("\(Int(changeInterval))s")
                                .frame(width: 40, alignment: .trailing)
                        }
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Status
            if let status = wallpaperManager.statusMessage {
                Text(status)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 600, height: 500)
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.image, .movie, .mpeg4Movie, .quickTimeMovie],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                selectedImages.append(contentsOf: urls)
            case .failure(let error):
                wallpaperManager.statusMessage = "Error selecting files: \(error.localizedDescription)"
            }
        }
        .onAppear {
            wallpaperManager.refreshCurrentWallpapers()
            
            // Connect wallpaper manager to app delegate for menu bar access
            if let appDelegate = NSApp.delegate as? AppDelegate {
                appDelegate.wallpaperManager = wallpaperManager
            }
        }
        .onDisappear {
            stopAutoChange()
        }
    }
    
    private func startAutoChange() {
        stopAutoChange()
        guard !selectedImages.isEmpty else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: changeInterval, repeats: true) { _ in
            currentWallpaperIndex = (currentWallpaperIndex + 1) % selectedImages.count
            let nextFile = selectedImages[currentWallpaperIndex]
            if wallpaperManager.isVideoFile(nextFile) {
                wallpaperManager.setVideoWallpaperOnAllScreens(nextFile)
            } else {
                wallpaperManager.setWallpaper(nextFile)
            }
        }
    }
    
    private func stopAutoChange() {
        timer?.invalidate()
        timer = nil
    }
} 