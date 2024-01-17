//
// VortexProxy.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// A proxy value that supports programmatic access to a Vortex particle system, allowing you
/// to issue a particle burst, adjust attraction, move the system, and more.
public struct VortexProxy {
    /// The particle system this proxy controls.
    public let particleSystem: VortexSystem?

    /// Issues an immediate burst of particles from the nearest particle system, based on whatever
    /// value you set for its `burstCount`.
    public let burst: () -> Void

    /// Tells particles in this system to move towards or away from a particular point, specified in
    /// screen coordinates. The strength of attraction or repulsion depends on the value you have
    /// set for `attractionStrength`.
    public let attractTo: (CGPoint?) -> Void

    /// Move the particle system to a new location, specified in screen coordinates.
    public func move(to newPosition: CGPoint) {
        guard let particleSystem else { return }

        particleSystem.position = [
            newPosition.x / particleSystem.lastDrawSize.width,
            newPosition.y / particleSystem.lastDrawSize.height
        ]
    }
}
