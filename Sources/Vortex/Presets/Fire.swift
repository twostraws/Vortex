//
// Fire.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in fire effect. Relies on a "circle" tag being present, which should be set to use 
    /// `.blendMode(.plusLighter)`.
    public static let fire: VortexSettings = {
        VortexSettings(
            tags: ["circle"],
            shape: .box(width: 0.1, height: 0),
            birthRate: 300,
            speed: 0.2,
            speedVariation: 0.2,
            angleRange: .degrees(10),
            attractionStrength: 2,
            colors: .ramp(.brown, .brown, .brown, .brown.opacity(0)),
            sizeVariation: 0.5,
            sizeMultiplierAtDeath: 0.1
        )
    }()
}

#Preview("Demonstrates a modified fire preset") {
    /// Here we modify the default fire settings to extend it across the bottom of the screen
    let floorOnFire = {
        var settings = VortexSettings(basedOn: .fire) 
        settings.position = [0.5, 1.02]
        settings.shape = .box(width: 1.0, height: 0)
        settings.birthRate = 600
        return settings 
    }()
    
    VortexView(floorOnFire) {
        Circle()
            .fill(.white)
            .frame(width: 32)
            .blur(radius: 3)
            .blendMode(.plusLighter)
            .tag("circle")
    }
}
