//
//  PickerView.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import SwiftUI

struct PickerView: View {
    
    @State private var selectedMood: Mood?
    @State private var selectedRuntime: Runtime?
    
    var body : some View {
        VStack(spacing: 16) {
            Text("What's the mood?")
                .font(.title)
                .bold()
            ForEach(Mood.allCases, id: \.self) {
                mood in
                OptionButton(
                    title: mood.title,
                    icon: mood.icon,
                    isSelected: selectedMood == mood,
                    action: { selectedMood = mood } )
            }
            Text("How much time?")
                .font(.title)
                .bold()
            ForEach(Runtime.allCases, id: \.self) {
                runtime in
                OptionButton(
                    title: runtime.title,
                    icon: runtime.icon,
                    isSelected: selectedRuntime == runtime,
                    action: { selectedRuntime = runtime } )
            }
        }
    }
}

#Preview {
    PickerView()
}
