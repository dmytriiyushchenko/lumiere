//
//  DetailView.swift
//  Lumiere
//
//  Created by Dmytrii  on 19.07.2026.
//

import SwiftUI
import YouTubePlayerKit

struct DetailView: View {
    @State private var detailVM = DetailViewModel()
    
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: movie.posterURL)
                Text(movie.title)
                Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                Text(movie.overview)
                    .padding()
                if let key = detailVM.trailerKey {
                    YouTubePlayerView(YouTubePlayer(source: .video(id: key)))
                        .frame(height: 220)
                    Link("Watch on YouTube",
                         destination: URL(string: "https://www.youtube.com/watch?v=\(key)")!)
                }
            }
            .task {
                await detailVM.loadTrailer(movieID: movie.id)
            }
        }
    }
}
