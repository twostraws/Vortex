//
// Fire.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in fire effect. Relies on a "circle" tag being present, which should be set to use 
    /// `.blendMode(.plusLighter)`.
    public static let fire: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            shape: .box(width: 0.1, height: 0),
            birthRate: 300,
            speed: 0.2,
            speedVariation: 0.2,
            angleRange: .degrees(10),
            attractionStrength: 2,
            colors: .ramp(.brown, .brown, .brown, .brown.opacity(0)),
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 0.1
        )
    }()
}
