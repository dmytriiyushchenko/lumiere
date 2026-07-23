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
        NavigationStack {
            List {
                ForEach(savedMovies) { movie in
                    NavigationLink(value: movie.id) {
                        HStack {
                            AsyncImage(url: movie.posterURL) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 50, height: 75)
                            Text(movie.title)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(savedMovies[index])
                    }
                }
            }
            .navigationDestination(for: Int.self) { id in DetailView(movieID: id) }
        }
    }
}
