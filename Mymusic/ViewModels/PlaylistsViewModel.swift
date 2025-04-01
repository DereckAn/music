import Foundation

class PlaylistsViewModel {
    private var playlists: [Playlist] = []
    
    func fetchPlaylists(completion: @escaping () -> Void) {
        MusicService.shared.fetchPlaylists { [weak self] fetchedPlaylists in
            self?.playlists = fetchedPlaylists
            DispatchQueue.main.async { completion() }
        }
    }
    
    var numberOfPlaylists: Int { playlists.count }
    
    func playlist(at index: Int) -> Playlist { playlists[index] }
}
