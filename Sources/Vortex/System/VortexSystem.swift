//
// VortexSystem.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// The main particle system generator class that powers Vortex.
@dynamicMemberLookup
public class VortexSystem: Identifiable, Equatable, Hashable {

    /// A public identifier  to satisfy Identifiable
    public let id = UUID()
    
    /// Equatable conformance
    public static func == (lhs: VortexSystem, rhs: VortexSystem) -> Bool {
        lhs.id == rhs.id
    }
    /// Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } 
    /// Virtual 'add' of the Settings properties to the vortex system
    subscript<T>(dynamicMember keyPath: KeyPath<VortexSettings, T>) -> T {
        settings[keyPath: keyPath]
    }

    // These properties are used for managing a live system, rather
    // than for configuration purposes.
    /// How many particles are waiting to be created. This is particularly useful when
    /// working with a birth rate below 1, where we want to create one particle every 5
    /// seconds for example.
    var outstandingParticles = 0.0

    /// The last time this particle system idled. This is used to allow intermittent particle
    /// emission, where particles are fired, then paused, then fired again, etc.
    var lastIdleTime = Date.now.timeIntervalSince1970

    /// The color ramp being used by particles in this particle system.
    var selectedColorRamp = 0

    /// The last time this particle system was updated.
    var lastUpdate = Date.now.timeIntervalSince1970

    /// The total number of particles emitted by this system.
    var emissionCount = 0

    /// An array containing all the live particles owned by this system.
    var particles = [Particle]()

    /// A set of all active particle systems spawned by this particle system.
    var activeSecondarySystems = Set<VortexSystem>()

    /// The last size at which this particle system was drawn. Used to let us move
    /// to a particle screen location on demand.
    var lastDrawSize = CGSize.zero

    // These properties control system-wide behavior.
    
    /// The configuration settings for a VortexSystem
    var settings: VortexSettings

    /// Initialise a particle system with a VortexSettings struct
    /// - Parameter settings: VortexSettings    
    /// The settings to be used for this particle system.   
    public init(_ settings: VortexSettings ) {
        self.settings = settings
        // Ensure that randomisation is set correctly if settings are copied.
        // (This is important when creating a secondary system)
        if case let .randomRamp(allColors) = settings.colors {
            selectedColorRamp = Int.random(in: 0..<allColors.count)
        }
    }
}
