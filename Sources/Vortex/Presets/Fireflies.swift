//
// Fireflies.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in firefly effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let fireflies: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            shape: .ellipse(radius: 0.5),
            birthRate: 200,
            lifespan: 2,
            speed: 0,
            speedVariation: 0.25,
            angleRange: .degrees(360),
            colors: .ramp(.yellow, .yellow, .yellow.opacity(0)),
            size: 0.01,
            sizeMultiplierAtDeath: 100
        )
    }()
}
