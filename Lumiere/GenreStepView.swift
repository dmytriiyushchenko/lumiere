//
//  GenreStepView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI

struct GenreStepView: View {
    let onSelect: (Genre) -> Void
    @State private var genreVM = GenreViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("What genre?")
                    .font(.title)
                    .bold()
                switch genreVM.state {
                case .idle, .loading:
                    ProgressView()
                case .loaded:
                    ForEach(genreVM.genres, id: \.id) { genre in
                        OptionButton(
                            title: genre.name,
                            icon: "film",
                            isSelected: false,
                            action: { onSelect(genre) }
                        )
                    }
                case .error(let message):
                    Text(message)
                        .foregroundStyle(.red)
                }
            }
        }
        .task { await genreVM.loadGenres() }
    }
}
