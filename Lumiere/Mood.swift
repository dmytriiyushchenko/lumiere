//
//  Mood.swift
//  Lumiere
//
//  Created by Dmytrii  on 27.06.2026.
//

import Foundation

enum Mood {
    case cozy
    case mindBending
    case feelGood
    case edgeOfSeat
    
    var title: String {
        switch self {
        case .cozy: "Cozy"
        case .mindBending: "Mind-Bending"
        case .feelGood: "Feel-Good"
        case .edgeOfSeat: "Edge of Seat"
        }
    }
    
    var icon: String {
        switch self {
        case .cozy: "moon.stars.fill"
        case .mindBending: "brain.head.profile"
        case .feelGood: "sun.max.fill"
        case .edgeOfSeat: "bolt.fill"
        }
    }
}
