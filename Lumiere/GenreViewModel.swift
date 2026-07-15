//
//  GenreViewModel.swift
//  Lumiere
//
//  Created by Dmytrii  on 07.07.2026.
//

import Foundation

@Observable
class GenreViewModel {
    var genres: [Genre] = []
    var state: LoadingState = .idle
    private let client: APIClient
    
    init(client: APIClient = TMDBClient()) {
        self.client = client
    }
    func loadGenres() async {
        state = .loading
        do {
            let url = URL(string:"https://api.themoviedb.org/3/genre/movie/list")!
            let response: GenreResponse = try await client.fetch(from: url)
            genres = response.genres
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
