//
//  Secrets.swift
//  Lumiere
//
//  Created by Dmytrii  on 06.07.2026.
//

import Foundation

nonisolated enum Secrets {
    static var tmdbToken: String {
        // An absent token used to fall through as "", so every request came back
        // 401 and the user was shown a network error for what is really a build
        // misconfiguration: Secrets.xcconfig is untracked and easy to forget.
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_TOKEN") as? String,
              !token.isEmpty else {
            assertionFailure("TMDB_TOKEN is missing from Info.plist — check Secrets.xcconfig")
            return ""
        }
        return token
    }
}
