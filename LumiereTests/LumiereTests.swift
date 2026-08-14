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
        // Arrange — зразок JSON, як його шле TMDB
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

        // Act — декодуємо тим самим шляхом, що й TMDBClient
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(MovieResponse.self, from: data)

        // Assert — перевіряємо, що вийшло саме те, що очікували
        #expect(result.results.count == 1)
        #expect(result.page == 1)
        #expect(result.results.first?.title == "Inception")
        #expect(result.results.first?.posterPath == "/inception.jpg")
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
}
