//
// Fire.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem.Settings { 
    /// A built-in fire effect. Relies on a "circle" tag being present, which should be set to use 
    /// `.blendMode(.plusLighter)`.
    public static let fire = VortexSystem.Settings { settings in
        settings.tags = ["circle"]
        settings.shape = .box(width: 0.1, height: 0)
        settings.birthRate = 300
        settings.speed = 0.2
        settings.speedVariation = 0.2
        settings.angleRange = .degrees(10)
        settings.attractionStrength = 2
        settings.colors = .ramp(.brown, .brown, .brown, .brown.opacity(0))
        settings.sizeVariation = 0.5
        settings.sizeMultiplierAtDeath = 0.1
    }
}

#Preview {
    let fireSettings = VortexSystem.Settings(from: .fire ) { settings in
        settings.position = [ 0.5, 1.03]
        settings.shape = .box(width: 1.0, height: 0)
        settings.birthRate = 600 
    } 
    VortexView(fireSettings) {
        Image.circle.blendMode(.plusLighter).frame(width: 16).tag("circle")
    } 
    .frame(width: 500, height: 500)
}
