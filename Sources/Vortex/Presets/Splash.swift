//
// Splash.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in splash effect, designed to accompany the rain present.
    /// Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    static let splash = VortexSettings { settings in
        
        var drops = VortexSettings { drops in 
            drops.tags = ["circle"]
            drops.birthRate = 5
            drops.emissionLimit = 10
            drops.speed = 0.4
            drops.speedVariation = 0.1
            drops.angleRange = .degrees(90)
            drops.acceleration = [0, 1]
            drops.colors = .random(
                VortexSystem.Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.7),
                VortexSystem.Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.6),
                VortexSystem.Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.5)
            )
            drops.size = 0.2
            drops.position = [0.5,1]
        }
        
        settings.tags = ["circle"]
        settings.secondarySettings = [drops]
        settings.position = [0.5, 1]
        settings.shape = .box(width: 1, height: 0)
        settings.birthRate = 5
        settings.lifespan = 0.001
        settings.speed = 0
        settings.colors = .single(.clear)
        settings.size = 0
    }
}

#Preview("Demonstrates a combination rain/splash preset") {
    ZStack {
        VortexView(.rain) {
            Circle()
                .fill(.white)
                .frame(width: 32)
                .tag("circle")
        }
        VortexView(.splash) {
            Circle()
                .fill(.white)
                .frame(width: 16)
                .tag("circle")
        } 
    }
}

