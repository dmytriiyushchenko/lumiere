//
//  OptionButton.swift
//  Lumiere
//
//  Created by Dmytrii  on 06.07.2026.
//

import SwiftUI

struct OptionButton: View {
    
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let action: () -> Void
    
    private var seed: UInt64 {
        UInt64(title.unicodeScalars.reduce(0) { $0 + $1.value })
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("PermanentMarker-Regular", size: 18))
                if let subtitle {
                    Text(subtitle)
                        .font(.custom("PatrickHand-Regular", size:15))
                        .opacity(0.65)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.lumiereCoral : Color.lumiereCream)
            .foregroundStyle(isSelected ? Color.lumiereCream : Color.lumiereInk)
            .overlay(
                RoughRectangle(seed: seed)
                    .stroke(Color.lumiereInk, lineWidth: 3)
            )
            .shadow(color: Color.lumiereInk.opacity(0.3), radius: 5, x: 2, y: 4)
        }
    }
}

