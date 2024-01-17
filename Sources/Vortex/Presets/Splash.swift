//
// Splash.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in splash effect, designed to accompany the rain present.
    /// Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let splash: VortexSystem = {
        let drops = VortexSystem(
            tags: ["circle"],
            birthRate: 5,
            emissionLimit: 10,
            speed: 0.4,
            speedVariation: 0.1,
            angleRange: .degrees(90),
            acceleration: [0, 1],
            colors: .random(
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.7),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.6),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.5)
            ),
            size: 0.2
        )

        let mainSystem = VortexSystem(
            tags: ["circle"],
            secondarySystems: [drops],
            position: [0.5, 1],
            shape: .box(width: 1, height: 0),
            birthRate: 5,
            lifespan: 0.001,
            speed: 0,
            colors: .single(.clear),
            size: 0
        )

        return mainSystem
    }()
}
