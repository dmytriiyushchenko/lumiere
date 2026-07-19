//
//  WatchlistView.swift
//  Lumiere
//
//  Created by Dmytrii  on 18.07.2026.
//

import SwiftUI
import SwiftData

struct WatchlistView: View {
    
    @Query private var savedMovies: [SavedMovie]
    @Environment(\.modelContext) private var modelContext

    
    var body: some View {
        List {
            ForEach(savedMovies) { movie in
                Text(movie.title)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(savedMovies[index])
                }
            }
        }
    }
}
