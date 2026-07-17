//
//  PickerView.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import SwiftUI

struct PickerView: View {
    
    @State private var selectedMood: Mood?
    @State private var selectedRuntime: Runtime?
    @State private var genreVM = GenreViewModel()
    @State private var selectedGenre: Genre?
    @State private var suggestionVM = SuggestionViewModel()
    
    var body : some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("What's the mood?")
                    .font(.title)
                    .bold()
                ForEach(Mood.allCases, id: \.self) {
                    mood in
                    OptionButton(
                        title: mood.title,
                        icon: mood.icon,
                        isSelected: selectedMood == mood,
                        action: { selectedMood = mood } )
                }
                Text("How much time?")
                    .font(.title)
                    .bold()
                ForEach(Runtime.allCases, id: \.self) {
                    runtime in
                    OptionButton(
                        title: runtime.title,
                        icon: runtime.icon,
                        isSelected: selectedRuntime == runtime,
                        action: { selectedRuntime = runtime } )
                }
                Text("What genre?")
                    .font(.title)
                    .bold()
                switch genreVM.state {
                case .idle, .loading:
                    ProgressView()
                case .loaded:
                    ForEach(genreVM.genres, id: \.id) {
                        genre in
                        OptionButton(
                            title: genre.name,
                            icon: "film",
                            isSelected: selectedGenre == genre,
                            action: { selectedGenre = genre } )
                    }
                case .error(let message):
                    Text(message)
                        .foregroundStyle(.red)
                }
                Button("Select film") {
                    Task {
                        await suggestionVM.loadMovies(genreID: selectedGenre?.id, maxMinutes: selectedRuntime?.maxMinutes)
                    }
                }
                if let movie = suggestionVM.currentMovie {
                    VStack {
                            AsyncImage(url: movie.posterURL)
                            Text(movie.title)
                            Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                        }
                    Button("Інший фільм") {
                        suggestionVM.showNext()
                    }
                    
                }
            }
        }
        .task {
            await genreVM.loadGenres()
        }
    }
}

#Preview {
    PickerView()
}
