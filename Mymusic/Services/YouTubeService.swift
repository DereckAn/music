import Foundation

class YouTubeService {
    static let shared = YouTubeService()
    private let apiKey = "TU_CLAVE_API" // Reemplaza con tu clave de YouTube Data API
    
    func searchVideos(query: String, completion: @escaping ([YouTubeVideo]) -> Void) {
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&type=video&key=\(apiKey)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                    let videos = result.items.map { YouTubeVideo(id: $0.id.id, title: $0.snippet.title, url: "https://www.youtube.com/watch?v=\($0.id.id)") }
                    completion(videos)
                } catch {
                    print("Error decoding YouTube response: \(error)")
                }
            }
        }.resume()
    }
}
