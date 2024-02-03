//
// RotationAxis.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension VortexSystem {
    /// The axis of rotation that can affect the positions of the particles
    public enum RotationAxis: Codable, CaseIterable {
        
        /// The x and y axes will change the position of a particle
        public static var allCases: Set<VortexSystem.RotationAxis> {
            [.x, .y]
        }
        
        /// Rotating along the x-axis will change the y-position of a particle
        case x
        
        /// Rotating along the y-axis will change the x-position of a particle
        case y
    }
}
