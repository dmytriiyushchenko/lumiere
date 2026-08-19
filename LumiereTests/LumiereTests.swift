//
//  LumiereTests.swift
//  LumiereTests
//
//  Created by Dmytrii  on 24.06.2026.
//

import Foundation
import Testing
@testable import Lumiere

struct LumiereTests {

    @Test func decodesMovieResponse() throws {
        // Arrange — a payload in the shape TMDB sends
        let json = """
        {
          "page": 1,
          "results": [
            {
              "id": 27205,
              "title": "Inception",
              "overview": "A thief who steals corporate secrets...",
              "poster_path": "/inception.jpg",
              "vote_average": 8.4,
              "release_date": "2010-07-15"
            }
          ],
          "total_pages": 500,
          "total_results": 10000
        }
        """
        let data = Data(json.utf8)

        // Act — decode the way TMDBClient does
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(MovieResponse.self, from: data)

        // Assert — the fields we rely on survived the round trip
        #expect(result.results.count == 1)
        #expect(result.page == 1)
        #expect(result.results.first?.title == "Inception")
        #expect(result.results.first?.posterPath == "/inception.jpg")
    }

    // Regression: `releaseDate` used to be non-optional, so a single entry
    // without `release_date` failed the decode of the whole page and the user
    // got an error screen instead of the other nineteen films. TMDB also sends
    // the key as an empty string, which decodes fine but renders as a blank.
    @Test func decodesEntriesWithoutAUsableReleaseDate() throws {
        let json = """
        {
          "page": 1,
          "results": [
            {
              "id": 1,
              "title": "Dated",
              "overview": "",
              "poster_path": null,
              "vote_average": 7.0,
              "release_date": "1994-09-10"
            },
            {
              "id": 2,
              "title": "Key missing",
              "overview": "",
              "poster_path": null,
              "vote_average": 6.0
            },
            {
              "id": 3,
              "title": "Key empty",
              "overview": "",
              "poster_path": null,
              "vote_average": 5.0,
              "release_date": ""
            }
          ],
          "total_pages": 1
        }
        """
        let data = Data(json.utf8)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(MovieResponse.self, from: data)

        #expect(result.results.count == 3)
        #expect(result.results[0].year == "1994")
        #expect(result.results[1].year == "-")
        #expect(result.results[2].year == "-")
    }

    // Regression: integer division printed "0h 45m" for anything under an hour
    // and "2h 0m" for a whole number of hours.
    @Test func formatsRuntimeWithoutEmptyUnits() {
        func movie(runtime: Int?) -> Movie {
            Movie(
                id: 1,
                title: "",
                overview: "",
                posterPath: nil,
                voteAverage: 0,
                releaseDate: nil,
                runtime: runtime
            )
        }

        #expect(movie(runtime: 45).runtimeText == "45m")
        #expect(movie(runtime: 120).runtimeText == "2h")
        #expect(movie(runtime: 145).runtimeText == "2h 25m")
        #expect(movie(runtime: nil).runtimeText == nil)
    }

    @Test func everyMoodHasGenres() {
        for energy in Energy.allCases {
            for intent in Intent.allCases {
                let profile = MoodProfile(energy: energy, intent: intent)

                #expect(!profile.genreIDs.isEmpty)

            }
        }
    }

    // Regression: two intents at the same energy level once shared `family`
    // and `music`, so "switch off" and "feel something" returned the same
    // blockbusters — popular films carry several genre tags at once.
    @Test func intentsAtSameEnergyShareNoGenres() {
        for energy in Energy.allCases {
            let sets = Intent.allCases.map {
                Set(MoodProfile(energy: energy, intent: $0).genreIDs)
            }
            for i in sets.indices {
                for j in sets.indices where j > i {
                    #expect(sets[i].intersection(sets[j]).isEmpty)
                }
            }
        }
    }

    // Regression: adding @Attribute(.unique) to `id` made an existing store
    // impossible to migrate, because one film had been saved twice. The store
    // is rebuilt on that failure, and a rebuild that leaves the write-ahead log
    // behind hands the new database a journal for a database that is gone.
    @Test func removesTheStoreWithItsSidecarFiles() throws {
        let directory = URL.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let store = directory.appending(path: "default.store")
        let files = [store,
                     directory.appending(path: "default.store-wal"),
                     directory.appending(path: "default.store-shm"),
                     directory.appending(path: "unrelated.txt")]
        for file in files {
            try Data().write(to: file)
        }

        removeStore(at: store)

        #expect(!FileManager.default.fileExists(atPath: files[0].path()))
        #expect(!FileManager.default.fileExists(atPath: files[1].path()))
        #expect(!FileManager.default.fileExists(atPath: files[2].path()))
        // Everything else in the directory is none of its business.
        #expect(FileManager.default.fileExists(atPath: files[3].path()))
    }
}
