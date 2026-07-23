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
        VStack(spacing: 16) {
            Text("How much time?")
                .font(.title)
                .bold()
            ForEach(Runtime.allCases, id: \.self) { runtime in
                OptionButton(
                    title: runtime.title,
                    icon: runtime.icon,
                    isSelected: false,
                    action: { onSelect(runtime) }  
                )
            }
        }
    }
}
