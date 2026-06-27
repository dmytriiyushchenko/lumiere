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
                Button {
                    selectedMood = mood
                } label: {
                    Label(mood.title, systemImage: mood.icon)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedMood == mood ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(selectedMood == mood ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            Text("How much time?")
                .font(.title)
                .bold()
            ForEach(Runtime.allCases, id: \.self) {
                runtime in
                Button {
                    selectedRuntime = runtime
                } label: {
                    Label(runtime.title, systemImage: runtime.icon)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedRuntime == runtime ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(selectedRuntime == runtime ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    PickerView()
}
