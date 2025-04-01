import Foundation

class YouTubeSearchViewModel {
    private var videos: [YouTubeVideo] = []
    
    func search(query: String, completion: @escaping () -> Void) {
        YouTubeService.shared.searchVideos(query: query) { [weak self] fetchedVideos in
            self?.videos = fetchedVideos
            DispatchQueue.main.async { completion() }
        }
    }
    
    var numberOfVideos: Int { videos.count }
    
    func video(at index: Int) -> YouTubeVideo { videos[index] }
    
    func sendVideoToServer(at index: Int, completion: @escaping (Bool) -> Void) {
        let video = videos[index]
        DownloadService.shared.sendToServer(url: video.url, completion: completion)
    }
}
