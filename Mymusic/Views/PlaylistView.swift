//
//  Playlists.swift
//  Mymusic
//
//  Created by Dereck Ángeles on 2/23/25.
//

import SwiftUI

struct PlaylistView: View {
    var body: some View {
        VStack {
            Image(systemName: "music.note.list")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            Text("Your Playlists")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Playlist")
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
