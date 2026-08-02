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
                                let saved = SavedMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath, year: movie.year, voteAverage: movie.voteAverage)
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
                        }
                    } else {
                        ProgressView()
                    }
                }
                .padding(.horizontal, Spacing.screenEdge)
            }
        }
    }
}
