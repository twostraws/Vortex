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
    public static let magic: VortexSystem = {
        VortexSystem(
            tags: ["sparkle"],
            shape: .ring(radius: 0.5),
            lifespan: 1.5,
            speed: 0,
            speedVariation: 0.2,
            angleRange: .degrees(360),
            angularSpeedVariation: [0, 0, 10],
            colors: .randomRamp(
                [.red, .red, .red.opacity(0)],
                [.pink, .pink, .pink.opacity(0)],
                [.orange, .orange, .orange.opacity(0)],
                [.blue, .blue, .blue.opacity(0)],
                [.green, .green, .green.opacity(0)],
                [.white, .white, .white.opacity(0)],
                fixed: false
            ),
            size: 0.5,
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 0.01
        )
    }()
}
