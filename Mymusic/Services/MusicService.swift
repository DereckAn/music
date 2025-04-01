import Foundation

class MusicService {
    static let shared = MusicService()
    private let baseURL = "http://tu-servidor:4533/rest/" // Cambia por tu URL de Navidrome
    private let username = "tu_usuario" // Cambia por tu usuario
    private let password = "tu_contraseña" // Cambia por tu contraseña
    
    func fetchSongs(completion: @escaping ([Song]) -> Void) {
        let urlString = "\(baseURL)getSongList?u=\(username)&p=\(password)&f=json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // Simula respuesta (ajusta según la API real de Navidrome)
                let songs = [Song(id: "1", title: "Sample Song", url: "http://tu-servidor:4533/stream/1")]
                completion(songs)
            }
        }.resume()
    }
    
    func fetchPlaylists(completion: @escaping ([Playlist]) -> Void) {
        let urlString = "\(baseURL)getPlaylists?u=\(username)&p=\(password)&f=json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // Simula respuesta
                let playlists = [Playlist(id: "1", name: "My Playlist", songs: [])]
                completion(playlists)
            }
        }.resume()
    }
}
