//
//  SuggestionViewModel.swift
//  Lumiere
//
//  Created by Dmytrii  on 16.07.2026.
//

import Foundation

@Observable
class SuggestionViewModel {
    var movies: [Movie] = []
    
    var currentIndex = 0
    func showNext() {
        currentIndex += 1
    }
    
    var currentMovie: Movie? {
        movies.indices.contains(currentIndex) ? movies[currentIndex] : nil 
    }
    
    
    var state: LoadingState = .idle
    private let client: APIClient
    
    init (client: APIClient = TMDBClient()) {
        self.client = client
    }
    func loadMovies(genreID:Int?, maxMinutes:Int?) async {
        state = .loading
        var components = URLComponents(string:"https://api.themoviedb.org/3/discover/movie")!
        var queryItems: [URLQueryItem] = []
        if let genreID = genreID {
            queryItems.append(URLQueryItem(name: "with_genres", value: "\(genreID)"))
        }
        if let maxMinutes = maxMinutes {
            queryItems.append(URLQueryItem(name: "with_runtime.lte", value: "\(maxMinutes)"))
        }
        components.queryItems = queryItems
        let url = components.url!
        do {
            let response: MovieResponse = try await client.fetch(from: url)
            movies = response.results
            currentIndex = 0 
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
