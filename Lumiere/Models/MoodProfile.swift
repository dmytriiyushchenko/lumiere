//
//  MoodProfile.swift
//  Lumiere
//
//  Created by Dmytrii  on 03.08.2026.
//

import Foundation

nonisolated struct MoodProfile {
    let energy: Energy
    let intent: Intent

    var genreIDs: [Int] { profile.include }
    var excludedGenreIDs: [Int] { profile.exclude }

    // Within one energy level the three intents must not share genres —
    // popular films carry several genre tags, so any overlap makes two
    // opposite moods return the same blockbusters.
    private var profile: (include: [Int], exclude: [Int]) {
        switch (energy, intent) {

        case (.drained, .escape):
            (include: [TMDBGenre.comedy, TMDBGenre.animation, TMDBGenre.family,
                       TMDBGenre.adventure, TMDBGenre.fantasy],
             exclude: [TMDBGenre.horror, TMDBGenre.war, TMDBGenre.thriller])

        case (.drained, .feel):
            (include: [TMDBGenre.drama, TMDBGenre.romance, TMDBGenre.music],
             exclude: [TMDBGenre.horror, TMDBGenre.action])

        case (.drained, .think):
            (include: [TMDBGenre.documentary, TMDBGenre.mystery, TMDBGenre.history],
             exclude: [TMDBGenre.horror, TMDBGenre.action, TMDBGenre.war])

        case (.steady, .escape):
            (include: [TMDBGenre.adventure, TMDBGenre.comedy, TMDBGenre.fantasy,
                       TMDBGenre.animation, TMDBGenre.family],
             exclude: [])

        case (.steady, .feel):
            (include: [TMDBGenre.drama, TMDBGenre.romance, TMDBGenre.music,
                       TMDBGenre.history, TMDBGenre.war],
             exclude: [])

        case (.steady, .think):
            (include: [TMDBGenre.mystery, TMDBGenre.crime, TMDBGenre.sciFi,
                       TMDBGenre.thriller, TMDBGenre.documentary],
             exclude: [])

        case (.charged, .escape):
            (include: [TMDBGenre.action, TMDBGenre.adventure, TMDBGenre.fantasy,
                       TMDBGenre.crime],
             exclude: [])

        case (.charged, .feel):
            (include: [TMDBGenre.war, TMDBGenre.history, TMDBGenre.drama,
                       TMDBGenre.romance, TMDBGenre.music],
             exclude: [])

        case (.charged, .think):
            (include: [TMDBGenre.sciFi, TMDBGenre.thriller, TMDBGenre.mystery,
                       TMDBGenre.documentary],
             exclude: [])
        }
    }
}
