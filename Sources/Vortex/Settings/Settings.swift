//
// Settings.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    
    /// Contains the variables used to configure a Vortex System for use with a `VortexView`.   
    /// Properties:-
    ///   - **tags**: The list of possible tags to use for this particle system. This might be the
    ///     full set of tags passed into a `VortexView`, but might also be a subset if
    ///     secondary systems use other tags.
    ///   - secondarySettings: The list of secondary settings for reac secondary system that can be created.
    ///     Defaults to an empty array.
    ///   - spawnOccasion: When this particle system should be spawned.
    ///     This is useful only for secondary systems. Defaults to `.onBirth`.
    ///   - position: The current position of this particle system, in unit space.
    ///     Defaults to [0.5, 0.5].
    ///   - shape: The shape of this particle system, which controls where particles
    ///     are created relative to the system's position. Defaults to `.point`.
    ///   - birthRate: How many particles are created every second. You can use
    ///     values below 1 here, e.g a birth rate of 0.2 means one particle being created
    ///     every 5 seconds. Defaults to 100.
    ///   - emissionLimit: The total number of particles this system should create.
    ///     A value of `nil` means no limit. Defaults to `nil`.
    ///   - emissionDuration: How long this system should emit particles for before
    ///     pausing, measured in seconds. Defaults to 1.
    ///   - idleDuration: How long this system should wait between particle
    ///     emissions, measured in seconds. Defaults to 0.
    ///   - burstCount: How many particles should be emitted when a burst is requested.
    ///     Defaults to 100.
    ///   - burstCountVariation: How much variation should be allowed in bursts.
    ///     Defaults to 0.
    ///   - lifespan: How long particles should live for, measured in seconds. Defaults
    ///     to 1.
    ///   - lifespanVariation: How much variation to allow in particle lifespan.
    ///     Defaults to 0.
    ///   - speed: The base rate of movement for particles. A speed of 1 means the
    ///     system will move from one side to the other in one second. Defaults to 1.
    ///   - speedVariation: How much variation to allow in particle speed. Defaults
    ///     to 0.
    ///   - angle: The base direction to launch new particles, where 0 is directly up. Defaults
    ///     to 0.
    ///   - angleRange: How much variation to use in particle launch direction. Defaults to 0.
    ///   - acceleration: How much acceleration to apply for particle movement.
    ///     Defaults to 0, meaning that no acceleration is applied.
    ///   - attractionCenter: A specific point particles should move towards or away
    ///     from, based on `attractionStrength`. A `nil` value here means
    ///     no attraction. Defaults to `nil`.
    ///   - attractionStrength: How fast to move towards `attractionCenter`,
    ///     when it is not `nil`. Defaults to 0
    ///   - dampingFactor: How fast movement speed should be slowed down. Defaults to 0.
    ///   - angularSpeed: How fast particles should spin. Defaults to `[0, 0, 0]`.
    ///   - angularSpeedVariation: How much variation to allow in particle spin speed.
    ///     Defaults to `[0, 0, 0]`.
    ///   - colors: What colors to use for particles made by this system. If `randomRamp`
    ///     is used then this system picks one possible color ramp to use. Defaults to
    ///     `.single(.white)`.
    ///   - size: How large particles should be drawn, where a value of 1 means 100%
    ///     the image size. Defaults to 1.
    ///   - sizeVariation: How much variation to use for particle size. Defaults to 0
    ///   - sizeMultiplierAtDeath: How how much bigger or smaller this particle should
    ///     be by the time it is removed. This is used as a multiplier based on the particle's initial
    ///     size, so if it starts at size 0.5 and has a `sizeMultiplierAtDeath` of 0.5, the
    ///     particle will finish at size 0.25. Defaults to 1.
    ///   - stretchFactor: How much to stretch this particle's image based on its movement
    ///     speed. Larger values cause more stretching. Defaults to 1 (no stretch).
    /// 
    public struct Settings: Sendable, Equatable, Hashable, Identifiable, Codable {
        /// Unique id. Set as variable to allow decodable conformance without compiler quibbles.
        public var id: UUID = UUID()
        
        // These properties control system-wide behavior.
        /// The current position of this particle system, in unit space.
        /// Defaults to the centre.
        public var position: SIMD2<Double> = [0.5, 0.5]
        
        /// The list of possible tags to use for this particle system. This might be the full set of
        /// tags passed into a `VortexView`, but might also be a subset if secondary systems
        /// use other tags.
        /// Defaults to "circle"
        public var tags: [String] = ["circle"]
        
        /// Whether this particle system should actively be emitting right now.
        public var isEmitting = true
        
        /// The list of secondary systems that can be created by this system.
        //    public var secondarySystems = [VortexSystem]()
        
        /// The list of secondary settings associated with this setting.
        public var secondarySettings = [Settings]()
        
        /// When this particle system should be spawned. This is useful only for secondary systems.
        /// Defaults to `.onBirth`
        public var spawnOccasion: SpawnOccasion = .onBirth
        
        // These properties control how particles are created.
        /// The shape of this particle system, which controls where particles are created relative to
        /// the system's position.
        /// Defaults to `.point`
        public var shape: Shape = .point
        
        /// How many particles are created every second. You can use values below 1 here, e.g
        /// a birth rate of 0.2 means one particle being created every 5 seconds.
        /// Defaults to 100
        public var birthRate: Double = 100
        
        /// The total number of particles this system should create. 
        /// The default value of `nil` means no limit.
        public var emissionLimit: Int? = nil
        
        /// How long this system should emit particles for before pausing, measured in seconds.
        /// Defaults to 1
        public var emissionDuration: TimeInterval = 1
        
        /// How long this system should wait between particle emissions, measured in seconds.
        /// Defaults to 0
        public var idleDuration: TimeInterval = 0
        
        /// How many particles should be emitted when a burst is requested.
        /// Defaults to 100
        public var burstCount: Int = 100
        
        /// How much variation should be allowed in bursts.
        /// Defaults to 0
        public var burstCountVariation: Int = 0
        
        /// How long particles should live for, measured in seconds.
        /// Defaults to 1
        public var lifespan: TimeInterval = 1
        
        /// How much variation to allow in particle lifespan.
        /// Defaults to 0
        public var lifespanVariation: TimeInterval = 0
        
        // These properties control how particles move.
        /// The base rate of movement for particles. 
        /// The default speed of 1 means the system will move
        /// from one side to the other in one second.
        public var speed: Double = 1
        
        /// How much variation to allow in particle speed.
        /// Defaults to 0
        public var speedVariation: Double = .zero
        
        /// The base direction to launch new particles, where 0 is directly up.
        /// Defaults to 0
        public var angle: Angle = .zero
        
        /// How much variation to use in particle launch direction.
        /// Defaults to 0
        public var angleRange: Angle = .zero
        
        /// How much acceleration to apply for particle movement. Set to 0 by default, meaning
        /// that no acceleration is applied.
        public var acceleration: SIMD2<Double> = [0,0]
        
        /// A specific point particles should move towards or away from, based
        /// on `attractionStrength`. A `nil` value here means no attraction.
        public var attractionCenter: SIMD2<Double>? = nil
        
        /// How fast to move towards `attractionCenter`, when it is not `nil`.
        /// Defaults to 0
        public var attractionStrength: Double = .zero
        
        /// How fast movement speed should be slowed down.
        /// Defaults to 0
        public var dampingFactor: Double = 0
        
        /// How fast particles should spin.
        /// Defaults to zero
        public var angularSpeed: SIMD3<Double> = [0,0,0]
        
        /// How much variation to allow in particle spin speed.
        /// Defaults to zero
        public var angularSpeedVariation: SIMD3<Double> = [0,0,0]
        
        // These properties determine how particles are drawn.
        
        
        /// How large particles should be drawn, where a value of 1, the default, means 100% of the image size.
        public var size: Double = 1
        
        /// How much variation to use for particle size. 
        /// Defaults to zero
        public var sizeVariation: Double = .zero
        
        /// How how much bigger or smaller this particle should be by the time it is removed.
        /// This is used as a multiplier based on the particle's initial size, so if it starts at size
        /// 0.5 and has a `sizeMultiplierAtDeath` of 0.5, the particle will finish
        /// at size 0.25.
        /// Defaults to zero
        public var sizeMultiplierAtDeath: Double = .zero
        
        /// How much to stretch this particle's image based on its movement speed. Larger values
        /// cause more stretching.
        /// Defaults to zero
        public var stretchFactor: Double = .zero
        
        /// What colors to use for particles made by this system. If `randomRamp` is used
        /// then this system picks one possible color ramp to use.
        public var colors: VortexSystem.ColorMode = .single(.white)  {
            didSet {
                if case let .randomRamp(allColors) = colors {
                    self.selectedColorRamp = Int.random(in: 0..<allColors.count)
                }
            }
        }
        /// The color ramp being used by particles in this particle system.
        var selectedColorRamp = 0
        
        /// VortexSettings initialisation.  
        /// - Parameters: None. Uses sensible default values on initialisation, with no parameters required.
        public init() {
        }
        
        /// Convenience init for VortexSettings initialisation.  Allows initialisation based on an existing settings struct, copies it into a new struct and modifiiesf it via a supplied closure
        /// - Parameters:
        ///  - from: `VortexSettings`  The base settings struct to be used as a base. Defaullt settings will be used if not supplied.
        ///  -  anonymous: `@escaping (inout VortexSettings)->Void` The closure which will modify the setting supplied in the first parameter
        /// e.g. 
        /// ```swift
        /// let fireSettings = VortexSettings(from: .fire ) { settings in
        ///         settings.position = [ 0.5, 1.03]
        ///         settings.shape = .box(width: 1.0, height: 0)
        ///         settings.birthRate = 600 
        ///     } 
        /// ```
        public init(from base: VortexSystem.Settings = VortexSystem.Settings(), _ modifiedBy: @escaping (_: inout VortexSystem.Settings) -> Void ) {
            // Take a copy of the base struct, and generate new id
            var newSettings = base
            newSettings.id = UUID()
            // Amend newSettings by calling the supplied closure
            modifiedBy(&newSettings)
            self = newSettings
        }
        
        /// Formerly used to make deep copies of the VortexSystem class so that secondary systems functioned correctly.
        /// No longer needed, but left here for backward compatibility.
        public func makeUniqueCopy() -> VortexSystem.Settings {
            return self
        }
    }  
}
