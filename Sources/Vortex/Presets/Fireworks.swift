//
// Fireworks.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in fireworks effect, using secondary systems that create sparkles and explosions.
    /// Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let fireworks: VortexSystem = {
        let sparkles = VortexSystem(
            tags: ["circle"],
            spawnOccasion: .onUpdate,
            emissionLimit: 1,
            lifespan: 0.5,
            speed: 0.05,
            angleRange: .degrees(90),
            size: 0.05
        )

        let explosion = VortexSystem(
            tags: ["circle"],
            spawnOccasion: .onDeath,
            position: [0.5, 1],
            birthRate: 100_000,
            emissionLimit: 500,
            speed: 0.5,
            speedVariation: 1,
            angleRange: .degrees(360),
            acceleration: [0, 1.5],
            dampingFactor: 4,
            colors: .randomRamp(
                [.white, .pink, .pink],
                [.white, .blue, .blue],
                [.white, .green, .green],
                [.white, .orange, .orange],
                [.white, .cyan, .cyan]
            ),
            size: 0.15,
            sizeVariation: 0.1,
            sizeMultiplierAtDeath: 0
        )

        let mainSystem = VortexSystem(
            tags: ["circle"],
            secondarySystems: [sparkles, explosion],
            position: [0.5, 1],
            birthRate: 2,
            emissionLimit: 1000,
            speed: 1.5,
            speedVariation: 0.75,
            angleRange: .degrees(60),
            dampingFactor: 2,
            size: 0.15,
            stretchFactor: 4
        )

        return mainSystem
    }()
}
