//
// Stars.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//


import SwiftUI

extension VortexSystem {
    /// A built-in star effect. Relies on a "circle" tag being present.
    public static let stars: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            shape: .box(width: 1.0, height: 1.0),
            birthRate: 20,
            lifespan: 5,
            speed: 0,
            speedVariation: 0.2,
            angleRange: .degrees(360),
            colors: .ramp(.blue.opacity(0), .blue, .purple, .purple.opacity(0)),
            size: 0.2,
            sizeVariation: 0.2,
            tiltDivisor: 100
        )
    }()
    
}
