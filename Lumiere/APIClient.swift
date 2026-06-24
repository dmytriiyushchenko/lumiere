//
//  APIClient.swift
//  Lumiere
//
//  Created by Dmytrii  on 20.06.2026.
//

import Foundation

protocol APIClient {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}
