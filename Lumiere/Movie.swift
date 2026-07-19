//
//  Movie.swift
//  Lumiere
//
//  Created by Dmytrii  on 04.06.2026.
//

import Foundation

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

