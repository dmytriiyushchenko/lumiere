//
//  Runtime.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import Foundation

enum Runtime {
    case short
    case medium
    case long
    
    var title: String {
        switch self {
        case .short: "Short"
        case .medium: "Medium"
        case .long: "Long"
        }
    }
    
    var icon: String {
        switch self {
        case .short: "hare.fill"
        case .medium: "clock.fill"
        case .long: "tortoise.fill"
        }
    }
}

