//
//  LoadingState.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.06.2026.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded([Movie])
    case error(String)
}
