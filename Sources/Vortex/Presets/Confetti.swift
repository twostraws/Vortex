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

    /// A customizable effect that creates confetti only when a burst is triggered.
    /// Relies on "confetti" tags being present – using `Rectangle`
    /// and `Circle` with frames of 16x16 works well.
    /// Note: `.resolve(in: EnvironmentValues)` is only available in macOS 14.0 or later
    /// - Parameters:
    ///   - colors: list of `SwiftUI.Color` to randomize in the confetti.
    ///   - env: reference to `@Environment(\.self)`
    /// - Returns: an instance of `VortexSystem` to pass into the VortexView
    @available(macOS 14.0, *)
    public static func accentedConfetti(
        colors: [SwiftUI.Color],
        in env: EnvironmentValues
    ) -> VortexSystem {
        var vColors: [VortexSystem.Color] = []
        for color in colors {
            let components = color.resolve(in: env)
            vColors
                .append(
                    Color(
                        red: Double(components.red),
                        green: Double(components.green),
                        blue: Double(components.blue),
                        opacity: Double(components.opacity)
                    )
                )
        }
        return VortexSystem(
            tags: ["confetti"],
            birthRate: 0,
            lifespan: 4,
            speed: 0.5,
            speedVariation: 0.5,
            angleRange: .degrees(90),
            acceleration: [0, 1],
            angularSpeedVariation: [4, 4, 4],
            colors: .random(vColors),
            size: 0.5,
            sizeVariation: 0.5
        )
    }
}
