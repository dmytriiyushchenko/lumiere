//
//  CraneStateView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI

struct CraneStateView: View {
    let imageName: String
    let message: String
    var animated: Bool = false

    @State private var flying = false

    var body: some View {
        VStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 160)
                .rotationEffect(.degrees(animated ? (flying ? 6 : -6) : 0))
                .animation(
                    animated ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : nil,
                    value: flying
                )
            Text(message)
                .font(.custom("PatrickHand-Regular", size: 20))
                .foregroundStyle(Color.lumiereInk)
        }
        .onAppear { flying = true }
    }
}
