//
//  Movie.swift
//  Lumiere
//
//  Created by Dmytrii  on 04.06.2026.
//

import Foundation

nonisolated struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var year: String {
        // TMDB drops `release_date` on some entries and sends it empty on others,
        // so the length matters as much as the presence.
        guard let releaseDate, releaseDate.count >= 4 else { return "-" }
        return String(releaseDate.prefix(4))
    }

    var runtimeText: String? {
        guard let runtime else { return nil }

        let hours = runtime / 60
        let minutes = runtime % 60

        if hours == 0 { return "\(minutes)m" }
        if minutes == 0 { return "\(hours)h" }
        return "\(hours)h \(minutes)m"
    }
}

