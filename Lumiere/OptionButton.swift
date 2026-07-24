//
//  OptionButton.swift
//  Lumiere
//
//  Created by Dmytrii  on 06.07.2026.
//

import SwiftUI

struct OptionButton: View {
    
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
            Button {
                action()
            } label: {
                Label(title, systemImage: icon)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSelected ? Color.lumiereCoral : Color.lumiereCream)
                    .foregroundStyle(isSelected ? Color.lumiereCream : Color.lumiereInk)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.lumiereInk, lineWidth: 3)
                    )
            }
    }
}

