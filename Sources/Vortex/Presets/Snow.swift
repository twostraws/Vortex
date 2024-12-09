//
// Snow.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in snow effect. Relies on a "circle" tag being present.
    static let snow = VortexSettings { settings in
        settings.tags = ["circle"]
        settings.position = [0.5, 0]
        settings.shape = .box(width: 1, height: 0)
        settings.birthRate = 50
        settings.lifespan = 10
        settings.speed = 0.2
        settings.speedVariation = 0.2
        settings.angle = .degrees(180)
        settings.angleRange = .degrees(20)
        settings.size = 0.25
        settings.sizeVariation = 0.4 
    }
}

#Preview("Demonstrates the snow preset") {
    // Use the snow preset, using the default symbol for the circle tag
    VortexView(.snow) {
        Circle()
            .fill(.white)
            .frame(width: 24)
            .blur(radius: 5)
            .tag("circle")
    }
}
