//
//  APIClient.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.06.2026.
//

import Foundation

protocol APIClient {
    nonisolated func fetch<T: Decodable>(from endpoint: Endpoint) async throws -> T
}
