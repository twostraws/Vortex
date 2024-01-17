//
// Particle.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// One particle in a Vortex system.
    public struct Particle: Hashable {
        /// The tag for this particle, which should match one of the tags attached to
        /// the SwiftUI views you're passing into a `VortexView`.
        var tag: String

        /// The current location of this particle, specified in unit space.
        var position: SIMD2<Double>

        /// The current speed of this particle.
        var speed: SIMD2<Double>

        /// The time this particle was created.
        var birthTime: TimeInterval

        /// How long this particle should live for, measured in seconds.
        var lifespan: TimeInterval

        /// The initial size this particle was created at.
        var initialSize: Double

        /// The current size of this particle. This is recomputed every time its system's
        /// `update()` method is called.
        var currentSize = 0.0

        /// The rotation angle of this particle.
        var angle = SIMD3<Double>()

        /// How fast this particle is spinning.
        var angularSpeed = SIMD3<Double>()

        /// The colors to use for rendering this particle over time.
        var colors: [Color]

        /// The current color to use for rendering this particle right now. This is recomputed
        /// every time its system's `update()` method is called.
        var currentColor = Color.white
    }
}
