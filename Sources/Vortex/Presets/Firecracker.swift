//
// Firecracker.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in firecracker effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let firecracker: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            birthRate: 500,
            lifespan: 0.4,
            speed: 3,
            speedVariation: 1,
            angle: .degrees(360),
            angleRange: .degrees(360),
            acceleration: [0, 3],
            dampingFactor: 2,
            colors: .ramp(.white, .yellow, .yellow.opacity(0)),
            size: 0.1,
            sizeVariation: 0.1,
            stretchFactor: 3,
            tiltDivisor: 40
        )
    }()
}
