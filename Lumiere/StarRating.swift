//
//  StarRating.swift
//  Lumiere
//
//  Created by Dmytrii  on 26.07.2026.
//

import SwiftUI

struct StarRating: View {
    let rating: Double
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: Double(index) <= rating ? "star.fill" : "star")
                    .foregroundStyle(Color.lumiereCoral)
            }
        }
    }
}
