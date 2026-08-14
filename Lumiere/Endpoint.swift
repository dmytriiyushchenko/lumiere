//
//  Endpoint.swift
//  Lumiere
//
//  Created by Dmytrii  on 07.08.2026.
//

import Foundation

nonisolated struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem] = []

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3" + path
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url
    }
}
