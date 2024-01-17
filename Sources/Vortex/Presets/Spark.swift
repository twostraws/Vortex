//
// Spark.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in spark effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let spark: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            birthRate: 150,
            emissionDuration: 0.2,
            idleDuration: 0.5,
            lifespan: 1.5,
            speed: 1.25,
            speedVariation: 0.2,
            angle: .degrees(330),
            angleRange: .degrees(20),
            acceleration: [0, 3],
            dampingFactor: 4,
            colors: .ramp(.white, .yellow, .yellow.opacity(0)),
            size: 0.1,
            sizeVariation: 0.1,
            stretchFactor: 8
        )
    }()
}
