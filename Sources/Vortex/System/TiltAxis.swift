//
// TiltAxis.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension VortexSystem {
    /// The axis of tilt that can affect the positions of the particles
    public enum TiltAxis: Codable, CaseIterable {
        
        /// The x and y axes will change the position of a particle
        public static var allCases: Set<VortexSystem.TiltAxis> {
            [.x, .y]
        }
        
        /// Tilting along the x-axis will change the y-position of a particle
        case x
        
        /// Tilting along the y-axis will change the x-position of a particle
        case y
    }
}
