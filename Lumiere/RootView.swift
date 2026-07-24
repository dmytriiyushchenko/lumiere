//
//  RootView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                TabView {
                    PickerView()
                        .tabItem { Label("Discover", systemImage: "film") }
                    WatchlistView()
                        .tabItem { Label("Watchlist", systemImage: "bookmark") }
                }
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeInOut(duration: 0.6)) {
                showSplash = false            
            }
        }
    }
}
