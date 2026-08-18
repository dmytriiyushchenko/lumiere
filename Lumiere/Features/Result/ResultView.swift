//
//  ResultView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI
import SwiftData
import Kingfisher

struct ResultView: View {
    let suggestionVM: SuggestionViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    switch suggestionVM.state {
                    case .idle, .loading:
                        ProgressView()

                    case .error(let message):
                        VStack(spacing: 8) {
                            Text("Something went wrong")
                                .font(.custom("PermanentMarker-Regular", size: 24))
                            Text(message)
                                .font(.custom("PatrickHand-Regular", size: 18))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(Color.lumiereInk)

                    case .loaded:
                        if let movie = suggestionVM.currentMovie {
                            NavigationLink(value: movie.id) {
                                VStack(spacing: 12) {
                                    KFImage(movie.posterURL)
                                        .placeholder {
                                            Color.gray.opacity(0.2)
                                                .aspectRatio(2.0 / 3.0, contentMode: .fit)
                                        }
                                        .resizable()
                                        .fade(duration:  0.2)
                                        .scaledToFit()
                                        .overlay(RoughRectangle().stroke(Color.lumiereInk, lineWidth: 3))
                                        .frame(maxWidth: .infinity, maxHeight: 400)

                                    Text(movie.title)
                                        .font(.custom("PermanentMarker-Regular", size: 22))
                                        .foregroundStyle(Color.lumiereInk)
                                        .lineLimit(2, reservesSpace: true)

                                    HStack(spacing: 6) {
                                        StarRating(rating: movie.voteAverage / 2)
                                        Text("\(movie.voteAverage / 2, specifier: "%.1f")")
                                            .font(.custom("PatrickHand-Regular", size: 16))
                                            .foregroundStyle(Color.lumiereInk)
                                    }
                                }
                            }

                            HStack(spacing: Spacing.option) {
                                Button {
                                    modelContext.insert(SeenMovie(id: movie.id))
                                    suggestionVM.markSeen(movie.id)
                                    suggestionVM.showNext()
                                } label: {
                                    Text("Another one")
                                        .font(.custom("PatrickHand-Regular", size: 20))
                                        .foregroundStyle(Color.lumiereInk)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.lumiereCream)
                                        .overlay(RoughRectangle(seed: 7).stroke(Color.lumiereInk, lineWidth: 3))
                                }
                                .buttonStyle(.plain)

                                Button {
                                    // `id` is unique on both models, so a repeated
                                    // insert updates the existing row instead of
                                    // duplicating it.
                                    let saved = SavedMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath, year: movie.year, voteAverage: movie.voteAverage)
                                    modelContext.insert(saved)
                                    modelContext.insert(SeenMovie(id: movie.id))
                                    suggestionVM.markSeen(movie.id)
                                } label: {
                                    Text("Save")
                                        .font(.custom("PatrickHand-Regular", size: 20))
                                        .foregroundStyle(Color.lumiereCream)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.lumiereCoral)
                                        .overlay(RoughRectangle(seed: 99).stroke(Color.lumiereInk, lineWidth: 3))
                                }
                                .buttonStyle(.plain)
                            }
                        } else {
                            VStack(spacing: 8) {
                                Text("That's everything")
                                    .font(.custom("PermanentMarker-Regular", size: 24))
                                Text("You've seen every film that fits. Try other filters.")
                                    .font(.custom("PatrickHand-Regular", size: 18))
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundStyle(Color.lumiereInk)
                        }
                    }
                }
                .padding(.horizontal, Spacing.screenEdge)
            }
        }
    }
}
