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
        if currentIndex >= movies.count - 3 {
            Task { await loadNextPage() }
        }
    }
    
    var currentPage = 1
    private var genreID: Int?
    private var maxMinutes: Int?
    private var seenIDs: [Int] = []
    
    
    var currentMovie: Movie? {
        movies.indices.contains(currentIndex) ? movies[currentIndex] : nil
    }
    
    
    var state: LoadingState = .idle
    private let client: APIClient
    
    init (client: APIClient = TMDBClient()) {
        self.client = client
    }
    func loadMovies(genreID: Int?, maxMinutes: Int?, seenIDs:[Int]) async {
        self.genreID = genreID
        self.maxMinutes = maxMinutes
        self.seenIDs = seenIDs
        currentPage = 1
        currentIndex = 0
        movies = []
        await fetchPage()
    }
    private var isLoadingNextPage = false

    func loadNextPage() async {
        guard !isLoadingNextPage else { return }  
        isLoadingNextPage = true
        currentPage += 1
        await fetchPage()
        isLoadingNextPage = false
    }
    private func fetchPage() async {
        state = .loading
        var components = URLComponents(string:"https://api.themoviedb.org/3/discover/movie")!
        var queryItems: [URLQueryItem] = []
        if let genreID = genreID {
            queryItems.append(URLQueryItem(name: "with_genres", value: "\(genreID)"))
        }
        if let maxMinutes = maxMinutes {
            queryItems.append(URLQueryItem(name: "with_runtime.lte", value: "\(maxMinutes)"))
        }
        queryItems.append(URLQueryItem(name: "page", value: "\(currentPage)"))
        components.queryItems = queryItems
        let url = components.url!
        do {
            let response: MovieResponse = try await client.fetch(from: url)
            movies += response.results.filter { !seenIDs.contains($0.id) }
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
