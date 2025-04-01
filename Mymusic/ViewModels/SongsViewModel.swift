import Foundation

class SongsViewModel {
    private var songs: [Song] = []
    
    func fetchSongs(completion: @escaping () -> Void) {
        MusicService.shared.fetchSongs { [weak self] fetchedSongs in
            self?.songs = fetchedSongs.map {
                var song = $0
                song.isLocal = DownloadService.shared.isSongLocal(title: song.title)
                return song
            }
            DispatchQueue.main.async { completion() }
        }
    }
    
    var numberOfSongs: Int { songs.count }
    
    func song(at index: Int) -> Song { songs[index] }
    
    func downloadSong(at index: Int, completion: @escaping () -> Void) {
        let song = songs[index]
        DownloadService.shared.downloadSong(from: song.url, title: song.title) { success in
            if success {
                self.songs[index].isLocal = true
                DispatchQueue.main.async { completion() }
            }
        }
    }
}
