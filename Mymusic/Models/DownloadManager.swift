// File: Models/DownloadManager.swift

import Foundation
import Combine

class DownloadManager: NSObject, ObservableObject, URLSessionDelegate {
    static let shared = DownloadManager()
    private var downloadSession: URLSession!
    
    @Published var activeDownloads: [URL: DownloadTask] = [:]
    
    struct DownloadTask {
        let task: URLSessionDownloadTask
        let title: String
        var progress: Float = 0.0
    }
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.yourapp.audioDownload")
        downloadSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func startDownload(videoURL: URL, title: String) {
        // Aquí integrarías yt-dlp para obtener el URL directo del audio
        // Este es un ejemplo con un servicio ficticio
        let downloadTask = downloadSession.downloadTask(with: videoURL)
        activeDownloads[videoURL] = DownloadTask(task: downloadTask, title: title)
        downloadTask.resume()
    }
    
    func localFileURL(for title: String) -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "\(title).mp3"
        return documentsPath.appendingPathComponent(fileName)
    }
}
