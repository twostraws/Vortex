//
// TiltDirection.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension VortexSystem {
    /// The tilt directions used to determine the axes of tilt that can affect the positions of the particles
    public enum TiltDirection: Codable, CaseIterable {
        
        /// Allow tilting along the x and y axes to change the position of a particle
        public static var allCases: Set<VortexSystem.TiltDirection> {
            [.x, .y]
        }
        
        /// Tilting along the x-axis will change the y-position of a particle
        case x
        
        /// Tilting along the y-axis will change the x-position of a particle
        case y
    }
}
