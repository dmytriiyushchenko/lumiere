//
//  WizardHeader.swift
//  Lumiere
//
//  Created by Dmytrii  on 25.07.2026.
//

import SwiftUI

struct WizardHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text("LUMIÈRE")
                .font(.custom("PermanentMarker-Regular", size: 20))
                .foregroundStyle(Color.lumiereCoral)
            VStack {
                Text(title)
                    .font(.custom("PermanentMarker-Regular", size: 34))
                    .foregroundStyle(Color.lumiereInk)
                Text(subtitle)
                    .font(.custom("PatrickHand-Regular", size: 18))
                    .foregroundStyle(Color.lumiereInk.opacity(0.7))
            }
        }
    }
}
