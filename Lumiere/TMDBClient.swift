//
//  TMDBClient.swift
//  Lumiere
//
//  Created by Dmytrii  on 23.06.2026.
//

import Foundation

final class TMDBClient: APIClient {
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Secrets.tmdbToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
