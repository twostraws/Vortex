//
// Fireworks.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in fireworks effect, using secondary systems that create sparkles and explosions.
    /// Relies on a symbol view tagged with "circle" being available to the VortexView.  (one such image is built-in)
    public static let fireworks = VortexSettings { settings in
        settings.tags = ["circle"]
        settings.position = [0.5, 1]
        settings.birthRate = 2
        settings.emissionLimit = 1000
        settings.speed = 1.5
        settings.speedVariation = 0.75
        settings.angleRange = .degrees(60)
        settings.dampingFactor = 2
        settings.size = 0.15
        settings.stretchFactor = 4
        
        var sparkles = VortexSettings { sparkle in
            sparkle.tags = ["sparkle"]
            sparkle.spawnOccasion = .onUpdate
            sparkle.emissionLimit = 1
            sparkle.lifespan = 0.5
            sparkle.speed = 0.05
            sparkle.angleRange = .degrees(180)
            sparkle.size = 0.05
        }
        
        var explosions = VortexSettings { explosion in 
            explosion.tags = ["circle"]
            explosion.spawnOccasion = .onDeath
            explosion.position = [0.5, 0.5]
            explosion.birthRate = 100_000
            explosion.emissionLimit = 500
            explosion.speed = 0.5
            explosion.speedVariation = 1
            explosion.angleRange = .degrees(360)
            explosion.acceleration = [0, 1.5]
            explosion.dampingFactor = 4
            explosion.colors = .randomRamp(
                [.white, .pink, .pink],
                [.white, .blue, .blue],
                [.white, .green, .green],
                [.white, .orange, .orange],
                [.white, .cyan, .cyan]
            )
            explosion.size = 0.15
            explosion.sizeVariation = 0.1
            explosion.sizeMultiplierAtDeath = 0
        }

        settings.secondarySettings = [sparkles, explosions]
    }
}

#Preview("Demonstrates multi-stage effects") {
    VortexView(.fireworks) {
        Circle()
            .fill(.white)
            .frame(width: 32)
            .blur(radius: 5)
            .blendMode(.plusLighter)
            .tag("circle")
    }
}
