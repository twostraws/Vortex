//
// Smoke.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in smoke effect. Relies on a "circle" tag being present.
    public static let smoke: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            shape: .box(width: 0.05, height: 0),
            lifespan: 3,
            speed: 0.1,
            speedVariation: 0.1,
            angleRange: .degrees(10),
            colors: .ramp(.gray, .gray.opacity(0)),
            size: 0.5,
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 2
        )
    }()
}
