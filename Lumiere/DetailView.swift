//
//  DetailView.swift
//  Lumiere
//
//  Created by Dmytrii  on 19.07.2026.
//

import SwiftUI
import YouTubePlayerKit
import Kingfisher

struct DetailView: View {
    @State private var detailVM = DetailViewModel()
    
    let movieID: Int
    
    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            ScrollView {
                if let movie = detailVM.movie {
                    VStack(alignment: .leading, spacing: 16) {
                        KFImage(movie.posterURL)
                            .placeholder {
                                Color.gray.opacity(0.2)
                                    .aspectRatio(2.0 / 3.0, contentMode: .fit)
                            }
                            .resizable()
                            .fade(duration: 0.2)
                            .scaledToFit()
                            .overlay(RoughRectangle().stroke(Color.lumiereInk, lineWidth: 3))
                            .frame(maxWidth: .infinity, maxHeight: 420)

                        Text(movie.title)
                            .font(.custom("PermanentMarker-Regular", size: 28))
                            .foregroundStyle(Color.lumiereInk)
                        
                        HStack(spacing: 8) {
                            Text(movie.year)
                            if let runtimeText = movie.runtimeText {
                                Text("·")
                                Text(runtimeText)
                            }
                            Text("·")
                            StarRating(rating: movie.voteAverage / 2)
                            Text("\(movie.voteAverage / 2, specifier: "%.1f")")
                        }
                        .font(.custom("PatrickHand-Regular", size: 16))
                        .foregroundStyle(Color.lumiereInk)
                        
                        Text(movie.overview)
                            .font(.custom("PatrickHand-Regular", size: 18))
                            .foregroundStyle(Color.lumiereInk)
                        
                        if let key = detailVM.trailerKey {
                            YouTubePlayerView(YouTubePlayer(source: .video(id: key)))
                                .frame(height: 220)
                                .overlay(RoughRectangle(seed: 42).stroke(Color.lumiereInk, lineWidth: 3))
                            
                            Link(destination: URL(string: "https://www.youtube.com/watch?v=\(key)")!) {
                                Text("Watch on YouTube")
                                    .font(.custom("PatrickHand-Regular", size: 18))
                                    .foregroundStyle(Color.lumiereInk)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .overlay(RoughRectangle(seed: 13).stroke(Color.lumiereInk, lineWidth: 3))
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.screenEdge)
                } else if case .error(let message) = detailVM.state {
                    Text(message)
                        .font(.custom("PatrickHand-Regular", size: 18))
                        .foregroundStyle(.red)
                        .padding()
                } else {
                    ProgressView()
                }
            }
        }
        .task {
            await detailVM.loadMovie(movieID: movieID)
            await detailVM.loadTrailer(movieID: movieID)
        }
    }
}
