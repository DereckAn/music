import Foundation

class DownloadService {
    static let shared = DownloadService()
    private let serverURL = "http://tu-servidor:5000/download" // Cambia por tu endpoint
    
    func sendToServer(url: String, completion: @escaping (Bool) -> Void) {
        guard let serverURL = URL(string: serverURL) else { return }
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["url": url]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(error == nil)
        }.resume()
    }
    
    func downloadSong(from url: String, title: String, completion: @escaping (Bool) -> Void) {
        let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(title).mp3")
        URLSession.shared.downloadTask(with: URL(string: url)!) { location, response, error in
            if let location = location {
                do {
                    try FileManager.default.moveItem(at: location, to: destination)
                    completion(true)
                } catch {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func isSongLocal(title: String) -> Bool {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(title).mp3")
        return FileManager.default.fileExists(atPath: path.path)
    }
}
