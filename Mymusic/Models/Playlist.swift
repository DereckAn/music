import Foundation

struct Playlist: Identifiable, Codable {
    let id: String
    let name: String
    let songs: [Song]
}
