//
// Rain.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in rain effect. Relies on a "circle" tag being present.
    public static let rain = VortexSettings { settings in
        settings.tags = ["circle"]
        settings.position = [0.5, 0 ]
        settings.shape = .box(width: 1.8, height: 0)
        settings.birthRate = 400
        settings.lifespan = 0.5
        settings.speed = 4.5
        settings.speedVariation = 2
        settings.angle = .degrees(190)
        settings.colors = .random(
            VortexSystem.Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.6),
            VortexSystem.Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.5),
            VortexSystem.Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.4)
        )
        settings.size = 0.09
        settings.sizeVariation = 0.05
        settings.stretchFactor = 12 
    }
    
}

#Preview("Demonstrates the rain preset") {
    VortexView(.rain) {
        Circle()
            .fill(.white)
            .frame(width: 32)
            .tag("circle")
    }
}
