//
//  IntentStepView.swift
//  Lumiere
//
//  Created by Dmytrii  on 03.08.2026.
//

import SwiftUI

struct IntentStepView: View {
    let onSelect: (Intent) -> Void

    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            VStack(spacing: Spacing.option) {
                WizardHeader(
                    title: "What do you want tonight?",
                    subtitle: "Last one — then we pick")
                Spacer()
                ForEach(Intent.allCases, id: \.self) { intent in
                    OptionButton(
                        title: intent.title,
                        subtitle: intent.subtitle,
                        isSelected: false,
                        action: { onSelect(intent) }
                    )
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.screenEdge)
            .frame(maxHeight: .infinity)
            .padding(.top, 16)
        }
    }
}
