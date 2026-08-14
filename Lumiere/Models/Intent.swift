//
//  Intent.swift
//  Lumiere
//
//  Created by Dmytrii  on 03.08.2026.
//

import Foundation

nonisolated enum Intent: CaseIterable {
    case escape
    case feel
    case think
    
    var title: String {
        switch self {
            case .escape: "Switch off"
            case .feel: "Feel something"
            case .think: "Make me think"
        }
    }
    
    var subtitle: String {
        switch self {
        case .escape: "Take me somewhere else"
        case .feel: "I'm looking for something"
        case .think: "Something with teeth"
        }
    }
}

