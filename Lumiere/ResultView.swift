//
//  ResultView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI
import SwiftData

struct ResultView: View {
    let suggestionVM: SuggestionViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var savedMovies: [SavedMovie]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let movie = suggestionVM.currentMovie {
                    NavigationLink(value: movie.id) {
                        VStack {
                            AsyncImage(url: movie.posterURL) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 400)
                            Text(movie.title)
                            Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                        }
                    }
                    Button("Another one") {
                        modelContext.insert(SeenMovie(id: movie.id))
                        suggestionVM.showNext()
                    }
                    Button("Save") {
                        let alreadySaved = savedMovies.contains { $0.id == movie.id }
                        guard !alreadySaved else { return }
                        let saved = SavedMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath)
                        modelContext.insert(saved)
                        modelContext.insert(SeenMovie(id: movie.id))
                    }
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
