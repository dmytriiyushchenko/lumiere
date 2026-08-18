//
//  SeenMovie.swift
//  Lumiere
//
//  Created by Dmytrii  on 21.07.2026.
//

import Foundation
import SwiftData

@Model
final class SeenMovie {
    // Both "Another one" and "Save" mark a film as seen, so the same id can be
    // inserted twice in one session.
    @Attribute(.unique) var id: Int

    init(id: Int) {
        self.id = id
    }
}
