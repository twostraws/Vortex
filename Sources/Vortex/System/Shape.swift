//
// Shape.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension VortexSystem {
    /// Controls where particles are created inside the particle system.
    public enum Shape: Codable {
        /// All particles are created from the center of the particle system.
        case point

        /// Particles are created somewhere inside a box measuring `width` x `height`.
        /// This values are specified in unit space.
        case box(width: Double, height: Double)

        /// Particles are created somewhere inside an ellipse measuring `radius`, which
        /// is specified in unit space.
        case ellipse(radius: Double)

        /// Particles are created somewhere along the edge of an ellipse measuring `radius`,
        /// which is specified in unit space.
        case ring(radius: Double)
    }
}
