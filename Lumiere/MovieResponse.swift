//
//  MovieResponse.swift
//  Lumiere
//
//  Created by Dmytrii  on 15.06.2026.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}
