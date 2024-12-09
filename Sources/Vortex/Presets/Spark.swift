//
// Spark.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in spark effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    static let spark = VortexSettings { settings in
        settings.tags = ["circle"]
        settings.birthRate = 150
        settings.emissionDuration = 0.2
        settings.idleDuration = 0.5
        settings.lifespan = 1.5
        settings.speed = 1.25
        settings.speedVariation = 0.2
        settings.angle = .degrees(330)
        settings.angleRange = .degrees(20)
        settings.acceleration = [0, 3]
        settings.dampingFactor = 4
        settings.colors = .ramp(.white, .yellow, .yellow.opacity(0))
        settings.size = 0.1
        settings.sizeVariation = 0.1
        settings.stretchFactor = 8 
    }
}

#Preview("Demonstrates the spark preset") {
    VortexView(.spark) {
        Circle()
            .fill(.white)
            .frame(width: 16)
            .tag("circle")
    }
}
