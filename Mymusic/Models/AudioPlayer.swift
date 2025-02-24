// File: Models/AudioPlayer.swift

import AVFoundation

class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    private var player: AVPlayer?
    
    @Published var isPlaying = false
    @Published var currentItem: DownloadedAudio?
    
    func play(_ audio: DownloadedAudio) {
        stop()
        currentItem = audio
        player = AVPlayer(url: audio.fileURL)
        player?.play()
        isPlaying = true
    }
    
    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
    }
}
