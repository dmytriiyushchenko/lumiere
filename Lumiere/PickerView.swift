//
//  PickerView.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import SwiftUI
import SwiftData


enum PickStep: Hashable {
    case genre
    case result
}

struct PickerView: View {
    @State private var path = NavigationPath()
    @State private var selectedRuntime: Runtime?
    @State private var selectedGenre: Genre?
    @State private var suggestionVM = SuggestionViewModel()
    @Query private var seenMovie: [SeenMovie]

    var body: some View {
        NavigationStack(path: $path) {
            TimeStepView(onSelect: { runtime in
                selectedRuntime = runtime
                path.append(PickStep.genre)
            })
            .navigationDestination(for: PickStep.self) { step in
                switch step {
                case .genre:
                    GenreStepView(onSelect: { genre in
                        selectedGenre = genre
                        Task {
                            await suggestionVM.loadMovies(
                                genreID: genre.id,
                                maxMinutes: selectedRuntime?.maxMinutes,
                                seenIDs: seenMovie.map { $0.id }
                            )
                        }
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
}

#Preview {
    PickerView()
}
