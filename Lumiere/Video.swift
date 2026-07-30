//
//  Video.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.07.2026.
//

import Foundation

nonisolated struct VideoResponse: Codable {
    let results: [Video]
}

nonisolated struct Video: Codable {
    let key: String
    let site: String
    let type: String
    let name: String
}

