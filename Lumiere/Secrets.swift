//
//  Secrets.swift
//  Lumiere
//
//  Created by Dmytrii  on 06.07.2026.
//

import Foundation

enum Secrets {
    static var tmdbToken: String {
        Bundle.main.object(forInfoDictionaryKey: "TMDB_TOKEN") as? String ?? ""
    }
}
