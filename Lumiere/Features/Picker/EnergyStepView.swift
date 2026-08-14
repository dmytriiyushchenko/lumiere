//
//  EnergyStepView.swift
//  Lumiere
//
//  Created by Dmytrii  on 03.08.2026.
//

import SwiftUI

struct EnergyStepView: View {
    let onSelect: (Energy) -> Void

    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            VStack(spacing: Spacing.option) {
                WizardHeader(
                    title: "How's your energy?",
                    subtitle: "There's no wrong answer")
                Spacer()
                ForEach(Energy.allCases, id: \.self) { energy in
                    OptionButton(
                        title: energy.title,
                        subtitle: energy.subtitle,
                        isSelected: false,
                        action: { onSelect(energy) }
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
