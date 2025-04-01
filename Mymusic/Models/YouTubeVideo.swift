import Foundation

struct YouTubeVideo: Identifiable, Codable {
    let id: String
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "videoId"
        case title
        case url
    }
}

struct YouTubeResponse: Codable {
    let items: [YouTubeItem]
}

struct YouTubeItem: Codable {
    let id: YouTubeVideo
    let snippet: Snippet
}

struct Snippet: Codable {
    let title: String
}
