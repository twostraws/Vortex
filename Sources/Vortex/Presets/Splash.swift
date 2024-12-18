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
    public static let splash: VortexSettings = {
        var drops = VortexSettings()
        drops.tags = ["circle"]
        drops.birthRate = 5
        drops.emissionLimit = 10
        drops.speed = 0.4
        drops.speedVariation = 0.1
        drops.angleRange = .degrees(90)
        drops.acceleration = [0, 1]
        drops.colors = .random(
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.7),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.6),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.5)
            )
        drops.size = 0.2

        var mainSettings = VortexSettings()
        mainSettings.tags = ["circle"]
        mainSettings.secondarySettings = [drops]
        mainSettings.position = [0.5, 1]
        mainSettings.shape = .box(width: 1, height: 0)
        mainSettings.birthRate = 5
        mainSettings.speed = 0
        mainSettings.colors = .single(.clear)
        mainSettings.size = 0

        return mainSettings
    }()
}

#Preview("Splash preview with rain") {
    ZStack {
        VortexView(.rain) {
            Circle()
                .fill(.white)
                .frame(width: 32)
                .tag("circle")
        }
        
        // Display the .splash preset using the default "circle" symbol.
        VortexView(.splash)
    }
}
