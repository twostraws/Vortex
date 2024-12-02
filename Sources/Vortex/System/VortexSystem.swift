//
// VortexSystem.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// The main particle system generator class that powers Vortex.
@dynamicMemberLookup
public class VortexSystem: Codable, Identifiable, Equatable, Hashable {

    /// The subset of properties we need to load and save to handle Codable correctly.
    enum CodingKeys: CodingKey { case vortexSettings }
    
    subscript<T>(dynamicMember keyPath: KeyPath<VortexSystem.Settings, T>) -> T {
        vortexSettings[keyPath: keyPath]
    }
    /// A random identifier for Identifiable conformance, that gives us Equatable and Hashable conformances by default.
    public let id = UUID()

    // These properties determine how particles are drawn.
    var vortexSettings: VortexSystem.Settings
    
    // These properties are used for managing a live system, rather
    // than for configuration purposes.
    
    /// How many particles are waiting to be created. This is particularly useful when
    /// working with a birth rate below 1, where we want to create one particle every 5
    /// seconds for example.
    var outstandingParticles = 0.0

    /// The last time this particle system idled. This is used to allow intermittent particle
    /// emission, where particles are fired, then paused, then fired again, etc.
    var lastIdleTime = Date.now.timeIntervalSince1970

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
    
    /// Initialise a particle system with a VortexSettings struct
    /// - Parameter `_`: VortexSettings    
    /// The settings to be used for this particle system.   
    public init( _ settings: VortexSystem.Settings ) {
        self.vortexSettings = settings
        // Ensure that randomisation is set correctly if settings are copied.
        // (This is important when creating a secondary system)
        if case let .randomRamp(allColors) = vortexSettings.colors {
            vortexSettings.selectedColorRamp = Int.random(in: 0..<allColors.count)
        }
        // Initialise all required secondary systems
        activeSecondarySystems = Set( 
            settings.secondarySettings.map{ VortexSystem($0) }
        )
    }

    /// Formerly used to make deep copies of the VortexSystem class so that secondary systems functioned correctly.
    /// No longer needed, but left here for backward compatibility.
    public func makeUniqueCopy() -> VortexSystem {
        return self
    } 
}
