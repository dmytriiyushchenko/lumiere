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
    private var seenIDs: Set<Int> = []

    /// Keeps the filter in sync while the user is still swiping. Without this the
    /// pool would be filtered against the snapshot taken at loadMovies time, and a
    /// film skipped a minute ago could come back on the next page of the same session.
    func markSeen(_ id: Int) {
        seenIDs.insert(id)
    }


    var currentMovie: Movie? {
        movies.indices.contains(currentIndex) ? movies[currentIndex] : nil
    }


    var state: LoadingState = .idle
    private let client: APIClient

    init(client: APIClient = TMDBClient()) {
        self.client = client
    }
    func loadMovies(genreIDs: [Int], excludedGenreIDs: [Int], maxMinutes: Int?, seenIDs: [Int]) async {
        self.genreIDs = genreIDs
        self.excludedGenreIDs = excludedGenreIDs
        self.maxMinutes = maxMinutes
        self.seenIDs = Set(seenIDs)
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

    private func fetchPage(isBackground: Bool = false) async {
        if !isBackground {
            state = .loading
        }
        let endpoint = Endpoint.discover(genreIDs: genreIDs,
                                         excludedGenreIDs: excludedGenreIDs,
                                         maxMinutes: maxMinutes,
                                         page: currentPage)
        do {
            let response: MovieResponse = try await client.fetch(from: endpoint)
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
