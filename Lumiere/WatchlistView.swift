//
//  WatchlistView.swift
//  Lumiere
//
//  Created by Dmytrii  on 18.07.2026.
//

import SwiftUI
import SwiftData
import Kingfisher

struct WatchlistView: View {

    @Query private var savedMovies: [SavedMovie]
    @Environment(\.displayScale) private var displayScale
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lumiereCream
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 8) {
                    Text("WATCHLIST")
                        .font(.custom("PermanentMarker-Regular", size: 30))
                        .foregroundStyle(Color.lumiereInk)
                        .padding(.horizontal, Spacing.screenEdge)
                        .padding(.top, 16)

                    List {
                        ForEach(savedMovies) { movie in
                            NavigationLink(value: movie.id) {
                                HStack(spacing: 12) {
                                    KFImage(movie.posterURL)
                                        .placeholder { Color.gray.opacity(0.2) }
                                        .downsampling(size: CGSize(width: 50, height: 75))
                                        .scaleFactor(displayScale)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 75)
                                        .clipped()
                                        .overlay(RoughRectangle(seed: UInt64(movie.id)).stroke(Color.lumiereInk, lineWidth: 2))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(movie.title)
                                            .font(.custom("PermanentMarker-Regular", size: 18))
                                            .foregroundStyle(Color.lumiereInk)
                                        HStack(spacing: 4) {
                                            Text(movie.year)
                                            Text("★")
                                                .foregroundStyle(Color.lumiereCoral)
                                            Text("\(movie.voteAverage / 2, specifier: "%.1f")")
                                        }
                                        .font(.custom("PatrickHand-Regular", size: 15))
                                        .foregroundStyle(Color.lumiereInk.opacity(0.65))
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color.lumiereCream)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                modelContext.delete(savedMovies[index])
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationDestination(for: Int.self) { id in DetailView(movieID: id) }
        }
    }
}
