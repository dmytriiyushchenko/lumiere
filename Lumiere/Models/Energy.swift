//
//  Energy.swift
//  Lumiere
//
//  Created by Dmytrii  on 03.08.2026.
//

import Foundation

nonisolated enum Energy: CaseIterable {
    case drained
    case steady
    case charged
    
    var title: String {
        switch self {
        case .drained:"Running on empty"
        case .steady:"Somewhere in between"
        case .charged:"Wired"
        }
    }
    
    var subtitle: String {
        switch self {
        case .drained:"Nothing demanding"
        case .steady:"Life-battery is not dead, but not full"
        case .charged:"Give me something big"
        }
    }
}

