//
//  RoughRectangle.swift
//  Lumiere
//
//  Created by Dmytrii  on 24.07.2026.
//

import SwiftUI

struct SeededGenerator: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { self.state = seed }
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

struct RoughRectangle: Shape {
    var seed: UInt64 = 42

    func path(in rect: CGRect) -> Path {
        var rng = SeededGenerator(seed: seed)
        func jit(_ amount: CGFloat) -> CGFloat {
            CGFloat.random(in: -amount...amount, using: &rng)
        }

        let tl = CGPoint(x: rect.minX + jit(3), y: rect.minY + jit(3))
        let tr = CGPoint(x: rect.maxX + jit(3), y: rect.minY + jit(3))
        let br = CGPoint(x: rect.maxX + jit(3), y: rect.maxY + jit(3))
        let bl = CGPoint(x: rect.minX + jit(3), y: rect.maxY + jit(3))

        var path = Path()
        path.move(to: tl)
        path.addQuadCurve(to: tr, control: CGPoint(x: rect.midX + jit(16), y: rect.minY + jit(6)))
        path.addQuadCurve(to: br, control: CGPoint(x: rect.maxX + jit(6), y: rect.midY + jit(16)))
        path.addQuadCurve(to: bl, control: CGPoint(x: rect.midX + jit(16), y: rect.maxY + jit(6)))
        path.addQuadCurve(to: tl, control: CGPoint(x: rect.minX + jit(6), y: rect.midY + jit(16)))
        return path
    }
}
