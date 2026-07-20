//
//  DetailViewModel.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.07.2026.
//

import Foundation

@Observable
final class DetailViewModel {
    var state: LoadingState = .idle
    var trailerKey: String?
    var movie: Movie?
    private let client: APIClient
    
    init (client: APIClient = TMDBClient()) {
        self.client = client
    }
    
    func loadTrailer(movieID: Int) async {
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos")!
        
        do {
            let response: VideoResponse = try await client.fetch(from: url)
            trailerKey = response.results.first(where: { $0.type == "Trailer" && $0.site == "YouTube" })?.key
        } catch {
        }
    }
    
    func loadMovie(movieID: Int) async {
        state = .loading
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)")!
        
        do {
            let movie: Movie = try await client.fetch(from: url)
            self.movie = movie
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}

