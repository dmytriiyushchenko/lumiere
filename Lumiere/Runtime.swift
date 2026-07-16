//
//  Runtime.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import Foundation

enum Runtime: CaseIterable {
    case short
    case medium
    case long
    
    var title: String {
        switch self {
        case .short: "До 1,5 години"
        case .medium: "До 2 годин"
        case .long: "Будь-яка"
        }
    }
    
    var icon: String {
        switch self {
        case .short: "hare.fill"
        case .medium: "clock.fill"
        case .long: "tortoise.fill"
        }
    }
    var maxMinutes: Int? {
        switch self {
        case .short: 90
        case .medium: 120
        case .long: nil
        }
    }
}

