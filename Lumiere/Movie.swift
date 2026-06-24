//
//  Movie.swift
//  Lumiere
//
//  Created by Dmytrii  on 04.06.2026.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String
}

