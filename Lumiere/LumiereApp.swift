//
//  LumiereApp.swift
//  Lumiere
//
//  Created by Dmytrii  on 04.06.2026.
//

import SwiftUI
import SwiftData

@main
struct LumiereApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedMovie.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {                                              // ← контейнер вкладок
                PickerView()
                    .tabItem { Label("Discover", systemImage: "film") }
                WatchlistView()
                    .tabItem { Label("Watchlist", systemImage: "bookmark") }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
