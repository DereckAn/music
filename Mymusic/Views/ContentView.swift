//
//  ContentView.swift
//  Mymusic
//
//  Created by Dereck Ángeles on 2/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            PlaylistView()
                .tabItem {
                    Label("Playlist", systemImage: "music.note.list")
                }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
