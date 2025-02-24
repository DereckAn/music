// File: Views/DownloadView.swift

import SwiftUI

struct DownloadView: View {
    @EnvironmentObject var downloadManager: DownloadManager
    @State private var youtubeURL = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Ingresa URL de YouTube", text: $youtubeURL)
                .textFieldStyle(.roundedBorder)
                .padding()
                .keyboardType(.URL)
                .autocapitalization(.none)
            
            Button(action: startDownload) {
                Label("Descargar Audio", systemImage: "arrow.down.circle")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(!isValidYouTubeURL)
        }
        .navigationTitle("Descargar Audio")
    }
    
    private var isValidYouTubeURL: Bool {
        youtubeURL.lowercased().contains("youtube.com/watch") ||
        youtubeURL.lowercased().contains("youtu.be/")
    }
    
    private func startDownload() {
        guard let videoID = extractVideoID(from: youtubeURL),
              let url = URL(string: "https://youtube.com/watch?v=\(videoID)") else {
            return
        }
        
        // Obtener título del video (implementar con API real)
        let placeholderTitle = "Audio_\(Date().timeIntervalSince1970)"
        downloadManager.startDownload(videoURL: url, title: placeholderTitle)
    }
    
    private func extractVideoID(from url: String) -> String? {
        let pattern = "(?<=v(=|/))([\\w-]+)|(?<=be/)([\\w-]+)"
        let regex = try? NSRegularExpression(pattern: pattern)
        let match = regex?.firstMatch(in: url, range: NSRange(url.startIndex..., in: url))
        
        guard let range = match?.range else { return nil }
        return String(url[Range(range, in: url)!])
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
