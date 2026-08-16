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

extension Endpoint {
    static func movie(id: Int) -> Endpoint {
        Endpoint(path: "/movie/\(id)")
    }
    static func videos(movieID: Int) -> Endpoint {
        Endpoint(path: "/movie/\(movieID)/videos")
    }
    static func discover(genreIDs: [Int],
                         excludedGenreIDs: [Int],
                         maxMinutes: Int?,
                         page: Int) -> Endpoint {
        var items: [URLQueryItem] = []

        if !genreIDs.isEmpty {
            let value = genreIDs.map(String.init).joined(separator: "|")
            items.append(URLQueryItem(name: "with_genres", value: value))
        }

        if !excludedGenreIDs.isEmpty {
            let value = excludedGenreIDs.map(String.init).joined(separator: ",")
            items.append(URLQueryItem(name: "without_genres", value: value))
        }

        if let maxMinutes {
            items.append(URLQueryItem(name: "with_runtime.lte", value: "\(maxMinutes)"))
        }

        // Going deeper into the pool surfaces films with almost no ratings — filter them out.
        items.append(URLQueryItem(name: "vote_count.gte", value: "100"))
        items.append(URLQueryItem(name: "page", value: "\(page)"))
        
        return Endpoint(path: "/discover/movie", queryItems: items)
    }
}


