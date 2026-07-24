//
//  SplashView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Image("crane-rest-nobg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 450)
                Text("Lumière")
                    .font(.custom("PermanentMarker-Regular", size: 52))
                    .foregroundStyle(Color.lumiereInk)
            }
        }
    }
}

#Preview { SplashView() }
