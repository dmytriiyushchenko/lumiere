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
    private let columns = [
        GridItem(.flexible(), spacing: Spacing.option),
        GridItem(.flexible(), spacing: Spacing.option)
    ]

    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    WizardHeader(
                        title: "What genre?",
                        subtitle: "Tap one to continue")
                    switch genreVM.state {
                    case .idle, .loading:
                        ProgressView()
                    case .loaded:
                        LazyVGrid(columns: columns, spacing: Spacing.option) {
                            ForEach(genreVM.genres, id: \.id) { genre in
                                OptionButton(
                                    title: genre.name,
                                    subtitle: nil,
                                    isSelected: false,
                                    action: { onSelect(genre) }
                                )
                            }
                        }
                    case .error(let message):
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal, Spacing.screenEdge)
            }
        }
        .task { await genreVM.loadGenres() }
    }
}
