//
//  DetailView.swift
//  Lumiere
//
//  Created by Dmytrii  on 19.07.2026.
//

import SwiftUI

struct DetailView: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            AsyncImage(url: movie.posterURL)
            Text(movie.title)
            Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
            Text(movie.overview)
                .padding()
        }
    }
}
