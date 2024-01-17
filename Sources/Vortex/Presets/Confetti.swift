//
// Confetti.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in effect that creates confetti only when a burst is triggered.
    /// Relies on "square" and "circle" tags being present – using `Rectangle`
    /// and `Circle` with frames of 16x16 works well.
    public static let confetti: VortexSystem = {
        VortexSystem(
            tags: ["square", "circle"],
            birthRate: 0,
            lifespan: 4,
            speed: 0.5,
            speedVariation: 0.5,
            angleRange: .degrees(90),
            acceleration: [0, 1],
            angularSpeedVariation: [4, 4, 4],
            colors: .random(.white, .red, .green, .blue, .pink, .orange, .cyan),
            size: 0.5,
            sizeVariation: 0.5
        )
    }()
}
