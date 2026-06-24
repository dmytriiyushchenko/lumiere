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
