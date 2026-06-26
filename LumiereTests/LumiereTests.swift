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
    
    @Test func decodesGenre() throws {
        let json = """
    { 
        "id": 28, 
        "name":"Action"
}
"""
        let data = Data(json.utf8)
        
        let decoder = JSONDecoder()
        
        let result = try decoder.decode(Genre.self, from: data)
        
        // Assert
        #expect(result.id == 28)
        #expect(result.name == "Action")
    }
}
