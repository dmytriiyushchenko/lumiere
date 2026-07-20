//
//  Video.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.07.2026.
//

import Foundation

struct VideoResponse: Codable {
    let results: [Video]
}

struct Video: Codable {
    let key: String
    let site: String
    let type: String
    let name: String
}

