//
// Magic.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in magic effect. Relies on a "sparkle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let magic: VortexSystem = VortexSystem(.magic)
}
extension VortexSystem.Settings {
    static let magic = VortexSystem.Settings { settings in
        settings.tags = ["sparkle"]
        settings.shape = .ring(radius: 0.5)
        settings.lifespan = 1.5
        settings.speed = 0
        settings.speedVariation = 0.2
        settings.angleRange = .degrees(360)
        settings.angularSpeedVariation = [0, 0, 10]
        settings.colors = .random(.red, .pink, .orange, .blue, .green, .white)
        settings.size = 0.5
        settings.sizeVariation = 0.5
        settings.sizeMultiplierAtDeath = 0.01
    }
}

#Preview {
    VortexView(.magic)
}
