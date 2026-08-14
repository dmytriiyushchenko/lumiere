//
//  NetworkError.swift
//  Lumiere
//
//  Created by Dmytrii  on 19.06.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

// Without this, the error screen shows
// "The operation couldn't be completed. (Lumiere.NetworkError error 1.)"
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "We couldn't build that search. Try picking again."
        case .invalidResponse:
            "Couldn't reach the film database. Check your connection and try again."
        case .decodingFailed:
            "The film database sent something we didn't expect. Try again in a moment."
        }
    }
}
