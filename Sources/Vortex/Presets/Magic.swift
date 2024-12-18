//
// Magic.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in magic effect. Relies on a "sparkle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let magic  = 
        VortexSettings(
            tags: ["sparkle"],
            shape: .ring(radius: 0.5),
            lifespan: 1.5,
            speed: 0,
            speedVariation: 0.2,
            angleRange: .degrees(360),
            angularSpeedVariation: [0, 0, 10],
            colors: .random(.red, .pink, .orange, .blue, .green, .white),
            size: 0.5,
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 0.01
        )
}
#Preview {
    VortexView(.magic)
}
