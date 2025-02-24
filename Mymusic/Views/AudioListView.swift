// File: Views/AudioListView.swift

import SwiftUI

struct AudioListView: View {
    @EnvironmentObject var downloadManager: DownloadManager
    @StateObject var audioPlayer = AudioPlayer.shared
    @State private var files: [DownloadedAudio] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(files) { audio in
                    AudioRow(audio: audio)
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteAudio(audio)
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Audios Descargados")
            .toolbar {
                Button(action: loadFiles) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .onAppear(perform: loadFiles)
        }
    }
    
    private func loadFiles() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            files = fileURLs
                .filter { $0.pathExtension == "mp3" }
                .map { DownloadedAudio(fileURL: $0, title: $0.deletingPathExtension().lastPathComponent, dateAdded: Date()) }
                .sorted(by: { $0.dateAdded > $1.dateAdded })
        } catch {
            print("Error loading files: \(error)")
        }
    }
    
    private func deleteAudio(_ audio: DownloadedAudio) {
        do {
            try FileManager.default.removeItem(at: audio.fileURL)
            loadFiles()
        } catch {
            print("Error deleting file: \(error)")
        }
    }
}

struct AudioRow: View {
    let audio: DownloadedAudio
    @ObservedObject var audioPlayer = AudioPlayer.shared
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(audio.title)
                    .font(.headline)
                Text("Descargado: \(audio.dateAdded.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: togglePlay) {
                Image(systemName: audioPlayer.currentItem == audio && audioPlayer.isPlaying ? "pause.circle" : "play.circle")
                    .font(.system(size: 30))
            }
        }
    }
    
    private func togglePlay() {
        if audioPlayer.currentItem == audio && audioPlayer.isPlaying {
            audioPlayer.stop()
        } else {
            audioPlayer.play(audio)
        }
    }
}

struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListView()
    }
}
