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
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    if let movie = suggestionVM.currentMovie {
                        NavigationLink(value: movie.id) {
                            VStack(spacing: 12) {
                                AsyncImage(url: movie.posterURL) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 400)
                                .overlay(RoughRectangle().stroke(Color.lumiereInk, lineWidth: 3))
                                Text(movie.title)
                                    .font(.custom("PatrickHand-Regular", size: 22))
                                    .foregroundStyle(Color.lumiereInk)
                                Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                                    .foregroundStyle(Color.lumiereInk)
                            }
                        }
                        Button {
                            modelContext.insert(SeenMovie(id: movie.id))
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
                            let alreadySaved = savedMovies.contains { $0.id == movie.id }
                            guard !alreadySaved else { return }
                            let saved = SavedMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath)
                            modelContext.insert(saved)
                            modelContext.insert(SeenMovie(id: movie.id))
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
                    } else {
                        CraneStateView(imageName: "crane-fly-nobg", message: "Finding your film…", animated: true)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}
