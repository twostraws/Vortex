//
// Confetti.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in effect that creates confetti only when a burst is triggered.
    /// Relies on "confetti" and "circle" tags being present – using `Rectangle`
    /// and `Circle` with frames of 16x16 works well.
    /// This declaration is deprecated. A VortexView should be invoked with a VortexSystem.Settings struct directly. See the example below.
    public static let confetti = VortexSystem(settings: .confetti)
}

extension VortexSystem.Settings {
    /// A built-in effect that creates confetti only when a burst is triggered.
    public static let confetti = VortexSystem.Settings() { settings in
        settings.tags = ["confetti", "circle"]
        settings.birthRate = 0
        settings.lifespan = 4
        settings.speed = 0.5
        settings.speedVariation = 0.5
        settings.angleRange = .degrees(90)
        settings.acceleration = [0, 1]
        settings.angularSpeedVariation = [4, 4, 4]
        settings.colors = .random(.white, .red, .green, .blue, .pink, .orange, .cyan)
        settings.size = 0.5
        settings.sizeVariation = 0.5
    }
}
