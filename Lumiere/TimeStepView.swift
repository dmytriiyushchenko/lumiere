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
            VStack(spacing: 16) {
                Text("How much time?")
                    .font(.custom("PermanentMarker-Regular", size: 34))
                    .foregroundStyle(Color.lumiereInk)
                ForEach(Runtime.allCases, id: \.self) { runtime in
                    OptionButton(
                        title: runtime.title,
                        icon: runtime.icon,
                        isSelected: false,
                        action: { onSelect(runtime) }
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
