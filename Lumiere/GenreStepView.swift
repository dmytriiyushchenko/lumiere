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
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("What genre?")
                        .font(.custom("PermanentMarker-Regular", size: 34))
                        .foregroundStyle(Color.lumiereInk)
                    switch genreVM.state {
                    case .idle, .loading:
                        CraneStateView(imageName: "crane-fly-nobg", message: "Finding genres…", animated: true)
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
                .padding(.horizontal, 24)
            }
        }
        .task { await genreVM.loadGenres() }
    }
}
