//
//  SuggestionViewModel.swift
//  Lumiere
//
//  Created by Dmytrii  on 16.07.2026.
//

import Foundation

@MainActor
@Observable
final class SuggestionViewModel {
    var movies: [Movie] = []
    
    var currentIndex = 0
    func showNext() {
        currentIndex += 1
        if currentIndex >= movies.count - 3 {
            Task { await loadNextPage() }
        }
    }
    
    var currentPage = 1
    private var totalPages = 1
    private var genreIDs: [Int] = []
    private var excludedGenreIDs: [Int] = []
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
    func loadMovies(genreIDs: [Int], excludedGenreIDs: [Int], maxMinutes: Int?, seenIDs: [Int]) async {
        self.genreIDs = genreIDs
        self.excludedGenreIDs = excludedGenreIDs
        self.maxMinutes = maxMinutes
        self.seenIDs = seenIDs
        // Page 1 of a popularity-sorted pool is always the same blockbusters,
        // whatever the filters. Starting deeper uses the pool we actually asked for.
        currentPage = Int.random(in: 1...20)
        currentIndex = 0
        movies = []
        await fetchPage()

        // A narrow profile may have fewer pages than the random start — fall back.
        if movies.isEmpty && currentPage > 1 {
            currentPage = 1
            await fetchPage()
        }
    }
    private var isLoadingNextPage = false
    
    func loadNextPage() async {
        guard !isLoadingNextPage else { return }
        guard currentPage < totalPages else { return }
        isLoadingNextPage = true
        currentPage += 1
        await fetchPage(isBackground: true)
        isLoadingNextPage = false
    }
    
    private func fetchPage(isBackground:Bool = false) async {
        if !isBackground {
            state = .loading
        }
        var components = URLComponents(string:"https://api.themoviedb.org/3/discover/movie")!
        var queryItems: [URLQueryItem] = []
        if !genreIDs.isEmpty {
            // пайп = АБО: підійде будь-який жанр із профілю настрою
            let value = genreIDs.map(String.init).joined(separator: "|")
            queryItems.append(URLQueryItem(name: "with_genres", value: value))
        }
        if !excludedGenreIDs.isEmpty {
            // кома = жодного з переліку
            let value = excludedGenreIDs.map(String.init).joined(separator: ",")
            queryItems.append(URLQueryItem(name: "without_genres", value: value))
        }
        if let maxMinutes = maxMinutes {
            queryItems.append(URLQueryItem(name: "with_runtime.lte", value: "\(maxMinutes)"))
        }
        // Going deeper into the pool surfaces films with almost no ratings — filter them out.
        queryItems.append(URLQueryItem(name: "vote_count.gte", value: "100"))
        queryItems.append(URLQueryItem(name: "page", value: "\(currentPage)"))
        components.queryItems = queryItems
        let url = components.url!
        do {
            let response: MovieResponse = try await client.fetch(from: url)
            movies += response.results.filter { !seenIDs.contains($0.id) }
            
            totalPages = response.totalPages
            
            if !isBackground {
                state = .loaded
            }
        } catch {
            if !isBackground {
                state = .error(error.localizedDescription)
            }
        }
    }
}
