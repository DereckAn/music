import SwiftUI
import WebKit
import AVKit
import Foundation

struct SearchView: View {
    @State private var currentURL: String = "https://www.youtube.com"
    @State private var showDownloadOptions = false
    @State private var isDownloading = false
    @State private var downloadProgress: Float = 0.0
    @State private var downloadMessage = ""
    @State private var downloadedFiles: [URL] = []
    @State private var showDownloadedFiles = false
    
    var body: some View {
        VStack {
            CustomWebView(url: URL(string: currentURL)!, onURLChange: { url in
                currentURL = url
            })
            
            if currentURL.contains("youtube.com/watch") {
                HStack {
                    Button(action: {
                        showDownloadOptions = true
                    }) {
                        Text("Descargar")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        loadDownloadedFiles()
                        showDownloadedFiles = true
                    }) {
                        Text("Ver Descargas")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            
            if isDownloading {
                ProgressView(value: downloadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                Text(downloadMessage)
            }
        }
        .actionSheet(isPresented: $showDownloadOptions) {
            ActionSheet(
                title: Text("Opciones de descarga"),
                buttons: [
                    .default(Text("Audio MP3")) { downloadUsingDocumentPicker(isAudio: true) },
                    .default(Text("Video 720p")) { downloadUsingDocumentPicker(quality: "22") },
                    .default(Text("Video 1080p")) { downloadUsingDocumentPicker(quality: "137+140") },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showDownloadedFiles) {
            DownloadedFilesView(files: downloadedFiles)
        }
    }
    
    func loadDownloadedFiles() {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            downloadedFiles = files.filter { $0.pathExtension == "mp4" || $0.pathExtension == "mp3" }
        } catch {
            print("Error loading files: \(error)")
        }
    }
    
    func downloadUsingDocumentPicker(isAudio: Bool = false, quality: String = "") {
        guard let videoID = extractVideoID(from: currentURL),
              let url = URL(string: "https://api.example.com/download?id=\(videoID)&format=\(isAudio ? "mp3" : "mp4")&quality=\(quality)") else {
            return
        }
        
        isDownloading = true
        downloadMessage = "Iniciando descarga..."
        
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    downloadMessage = "Error: \(error.localizedDescription)"
                    isDownloading = false
                }
                return
            }
            
            guard let localURL = localURL else { return }
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = isAudio ? "download.mp3" : "download.mp4"
            let destinationURL = documentsPath.appendingPathComponent(fileName)
            
            do {
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(atPath: destinationURL.path)
                }
                try FileManager.default.moveItem(at: localURL, to: destinationURL)
                
                DispatchQueue.main.async {
                    downloadMessage = "Descarga completada"
                    isDownloading = false
                    loadDownloadedFiles()
                }
            } catch {
                DispatchQueue.main.async {
                    downloadMessage = "Error guardando archivo: \(error.localizedDescription)"
                    isDownloading = false
                }
            }
        }
        
        task.resume()
    }
    
    func extractVideoID(from url: String) -> String? {
        guard let urlComponents = URLComponents(string: url),
              let queryItems = urlComponents.queryItems else { return nil }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
}

struct CustomWebView: UIViewRepresentable {
    let url: URL
    let onURLChange: (String) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CustomWebView
        
        init(_ parent: CustomWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                parent.onURLChange(url)
            }
        }
    }
}

struct DownloadedFilesView: View {
    let files: [URL]
    @State private var selectedFile: URL?
    @State private var showPlayer = false
    
    var body: some View {
        NavigationView {
            List(files, id: \.self) { file in
                VStack(alignment: .leading) {
                    Text(file.lastPathComponent)
                    
                    HStack {
                        Button("Reproducir") {
                            selectedFile = file
                            showPlayer = true
                        }
                        
                        Spacer()
                        
                        Button("Compartir") {
                            shareFile(file)
                        }
                    }
                }
            }
            .navigationTitle("Archivos Descargados")
            .sheet(isPresented: $showPlayer) {
                if let url = selectedFile {
                    PlayerView(url: url)
                }
            }
        }
    }
    
    func shareFile(_ file: URL) {
        let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct PlayerView: View {
    let url: URL
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
