//
//  PickerView.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import SwiftUI
import SwiftData


enum PickStep: Hashable {
    case energy
    case intent
    case result
}

struct PickerView: View {
    @State private var path = NavigationPath()
    @State private var selectedRuntime: Runtime?
    @State private var selectedEnergy: Energy?
    @State private var suggestionVM = SuggestionViewModel()
    @Query private var seenMovie: [SeenMovie]

    var body: some View {
        NavigationStack(path: $path) {
            TimeStepView(onSelect: { runtime in
                selectedRuntime = runtime
                path.append(PickStep.energy)
            })
            .navigationDestination(for: PickStep.self) { step in
                switch step {
                case .energy:
                    EnergyStepView(onSelect: { energy in
                        selectedEnergy = energy
                        path.append(PickStep.intent)
                    })
                case .intent:
                    IntentStepView(onSelect: { intent in
                        startSearch(intent: intent)
                        path.append(PickStep.result)
                    })
                case .result:
                    ResultView(suggestionVM: suggestionVM)
                }
            }
            .navigationDestination(for: Int.self) { id in
                DetailView(movieID: id)
            }
        }
    }

    private func startSearch(intent: Intent) {
        guard let energy = selectedEnergy else { return }
        let profile = MoodProfile(energy: energy, intent: intent)

        Task {
            await suggestionVM.loadMovies(
                genreIDs: profile.genreIDs,
                excludedGenreIDs: profile.excludedGenreIDs,
                maxMinutes: selectedRuntime?.maxMinutes,
                seenIDs: seenMovie.map { $0.id }
            )
        }
    }
}

#Preview {
    PickerView()
}
