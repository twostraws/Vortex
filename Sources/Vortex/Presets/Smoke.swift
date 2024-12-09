//
// Smoke.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in smoke effect. Relies on a "circle" tag being present.
    static let smoke = VortexSettings { settings in
        settings.tags = ["circle"]
        settings.shape = .box(width: 0.05, height: 0)
        settings.lifespan = 3
        settings.speed = 0.1
        settings.speedVariation = 0.1
        settings.angleRange = .degrees(10)
        settings.colors = .ramp(.gray, .gray.opacity(0))
        settings.size = 0.5
        settings.sizeVariation = 0.5
        settings.sizeMultiplierAtDeath = 2 
    }
}

#Preview("Demonstrates the smoke preset") {
    VortexView(.smoke) {
        Circle()
            .fill(.white)
            .frame(width: 64)
            .blur(radius: 10)
            .tag("circle")
    }
}
