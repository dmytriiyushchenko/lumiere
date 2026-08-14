//
//  TimeStepView.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI

struct TimeStepView: View {
    let onSelect: (Runtime) -> Void

    var body: some View {
        ZStack {
            Color.lumiereCream
                .ignoresSafeArea()
            VStack(spacing: Spacing.option) {
                WizardHeader(
                    title: "How much time?",
                    subtitle: "Pick one — we'll take it from here")
                Spacer()
                ForEach(Runtime.allCases, id: \.self) { runtime in
                    OptionButton(
                        title: runtime.title,
                        subtitle: runtime.subtitle,
                        isSelected: false,
                        action: { onSelect(runtime) }
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
