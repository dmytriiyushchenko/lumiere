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
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedMovie.self,
            SeenMovie.self,
        ])

        do {
            let onDisk = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            return try ModelContainer(for: schema, configurations: [onDisk])
        } catch {
            // The store on disk is unreadable or could not be migrated. Losing the
            // watchlist for this launch is bad; refusing to open at all is worse.
            assertionFailure("Could not open the stored library, falling back to memory: \(error)")
        }

        do {
            let inMemory = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: [inMemory])
        } catch {
            // Nothing on the device can cause this: the schema itself is invalid.
            fatalError("Could not create an in-memory ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
