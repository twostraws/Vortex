//
// ColorMode.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension VortexSystem {
    /// Controls how colors are applied to particles inside a Vortex system.
    public enum ColorMode: Codable {
        /// Particles should always be created with a single color.
        case single(_ color: Color)

        /// Particles should be created using one of several possible colors.
        case random(_ colors: [Color])

        /// Particles should move through an array of colors over time.
        case ramp(_ colors: [Color])

        /// The system should select one random color array, and give that
        /// to each particle it creates.
        case randomRamp(_ colors: [[Color]])

        /// A convenience method to create random colors because Swift does not
        /// support variadic enum cases.
        public static func random(_ colors: Color...) -> ColorMode {
            .random(colors)
        }

        /// A convenience method to create color ramps because Swift does not
        /// support variadic enum cases.
        public static func ramp(_ colors: Color...) -> ColorMode {
            .ramp(colors)
        }

        /// A convenience method to create random color ramps because Swift does not
        /// support variadic enum cases.
        public static func randomRamp(_ colors: [Color]...) -> ColorMode {
            .randomRamp(colors)
        }
    }
}
