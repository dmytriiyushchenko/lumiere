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
    let runtime: Int?
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var year: String {
        String(releaseDate.prefix(4))
    }
    
    var runtimeText: String? {
        guard let runtime else { return nil }
        return "\(runtime / 60)h \(runtime % 60)m"
    }
}

