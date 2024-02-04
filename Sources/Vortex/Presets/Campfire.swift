//
// Campfire.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in campfire effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let campfire: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            position: [0.5, 1],
            shape: .box(width: 0.2, height: 0),
            birthRate: 325,
            speed: 0.2,
            speedVariation: 0.2,
            angleRange: .degrees(10),
            attractionStrength: 2,
            colors: .ramp(.brown, .brown, .brown, .brown.opacity(0)),
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 0.1,
            rotationAxes: [.y]
        )
    }()
}
