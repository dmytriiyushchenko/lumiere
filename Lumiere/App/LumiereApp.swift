//
//  LumiereApp.swift
//  Lumiere
//
//  Created by Dmytrii  on 04.06.2026.
//

import SwiftUI
import SwiftData
import OSLog

@main
struct LumiereApp: App {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedMovie.self,
            SeenMovie.self,
        ])
        let onDisk = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [onDisk])
        } catch {
            // Old data can be impossible to migrate rather than merely damaged:
            // making id unique fails against a store that already holds the same
            // film twice. Recovering by hand is not something a user can do, so
            // the store is thrown away and built again from the current schema.
            Logger.storage.error("Rebuilding an unreadable store: \(error)")
            removeStore(at: onDisk.url)
        }

        do {
            return try ModelContainer(for: schema, configurations: [onDisk])
        } catch {
            // A store that was just created cannot be the problem, so the schema is.
            assertionFailure("Could not rebuild the stored library: \(error)")
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

/// Deletes a SQLite store together with the two sidecar files it is useless without.
func removeStore(at url: URL) {
    let directory = url.deletingLastPathComponent()

    // SQLite keeps the write-ahead log and the shared memory file next to the
    // store. Leaving them behind hands the fresh store a journal describing a
    // database that no longer exists.
    for suffix in ["", "-wal", "-shm"] {
        let file = directory.appending(path: url.lastPathComponent + suffix)
        try? FileManager.default.removeItem(at: file)
    }
}

private extension Logger {
    static let storage = Logger(subsystem: Bundle.main.bundleIdentifier ?? "Lumiere",
                                category: "storage")
}
