//
// SpawnOccasion.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension VortexSystem {
    /// Controls when secondary systems are created.
    public enum SpawnOccasion: Codable {
        /// Creates a new system at the same time as creating a new particle.
        case onBirth

        /// Creates a new system at the same time as destroying a particle.
        case onDeath

        /// Creates a new system every time `update()` is called.
        case onUpdate
    }
}
