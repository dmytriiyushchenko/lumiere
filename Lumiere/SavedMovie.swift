//
//  SavedMovie.swift
//  Lumiere
//
//  Created by Dmytrii  on 18.07.2026.
//

import Foundation
import SwiftData

@Model
final class SavedMovie {
    var id: Int
    var title: String
    var posterPath: String?
    
    init(id: Int, title: String, posterPath: String? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }
}
