//
//  DetailViewModel.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.07.2026.
//

import Foundation

@MainActor
@Observable
final class DetailViewModel {
    var state: LoadingState = .idle
    var trailerKey: String?
    var movie: Movie?
    private let client: APIClient

    init(client: APIClient = TMDBClient()) {
        self.client = client
    }

    func loadTrailer(movieID: Int) async {
        do {
            let response: VideoResponse = try await client.fetch(from: .videos(movieID: movieID))
            trailerKey = response.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })?.key
        } catch {
        }
    }

    func loadMovie(movieID: Int) async {
        state = .loading

        do {
            let movie: Movie = try await client.fetch(from: .movie(id: movieID))
            self.movie = movie
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

