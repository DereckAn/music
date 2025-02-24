// MARK: - Modelos
// File: Models/DownloadedAudio.swift

import Foundation

struct DownloadedAudio: Identifiable, Hashable {
    let id = UUID()
    let fileURL: URL
    let title: String
    let dateAdded: Date
}
