//
//  HomeTab.swift
//  Mymusic
//
//  Created by Dereck Ángeles on 2/23/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            Text("Welcome to MyMusic!")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
