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
    subscript<T>(dynamicMember keyPath: KeyPath<VortexSystem.Settings, T>) -> T {
        vortexSettings[keyPath: keyPath]
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
    var vortexSettings: VortexSystem.Settings

    /// Backwards compatibility only - use is deprecated
    /// The secondary systems to be used in the particle system
    var secondarySystems: [VortexSystem] = []
    
    /// Initialise a particle system with a VortexSettings struct
    /// - Parameter settings: VortexSettings    
    /// The settings to be used for this particle system.   
    public init( settings: VortexSystem.Settings ) {
        self.vortexSettings = settings
        // Ensure that randomisation is set correctly if settings are copied.
        // (This is important when creating a secondary system)
        if case let .randomRamp(allColors) = vortexSettings.colors {
            selectedColorRamp = Int.random(in: 0..<allColors.count)
        }
    }

    /// Creates a new particle system. - Deprecated.
    /// Most values here have sensible defaults, but you do need
    /// to provide a list of tags matching whatever you're using with `VortexView`.
    /// - Parameters:
    ///   - tags: The list of possible tags to use for this particle system. This might be the
    ///     full set of tags passed into a `VortexView`, but might also be a subset if
    ///     secondary systems use other tags.
    //     **Secondary systems through this initialiser cannot be supported and will generate an error 
    ///   - secondarySystems: The list of secondary systems that can be created
    ///     by this system. Always set to an empty array.
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
    /// For backward compatibility only
    @available(*, deprecated, message: "Initialise a VortexSystem with the `settings:` parameter to remove this warning. ")
    public init(
        tags: [String],
        secondarySystems: [VortexSystem] = [],
        spawnOccasion: SpawnOccasion = .onBirth,
        position: SIMD2<Double> = [0.5, 0.5],
        shape: Shape = .point,
        birthRate: Double = 100,
        emissionLimit: Int? = nil,
        emissionDuration: Double = 1,
        idleDuration: Double = 0,
        burstCount: Int = 100,
        burstCountVariation: Int = 0,
        lifespan: TimeInterval = 1,
        lifespanVariation: TimeInterval = 0,
        speed: Double = 1,
        speedVariation: Double = 0,
        angle: Angle = .zero,
        angleRange: Angle = .zero,
        acceleration: SIMD2<Double> = [0, 0],
        attractionCenter: SIMD2<Double>? = nil,
        attractionStrength: Double = 0,
        dampingFactor: Double = 0,
        angularSpeed: SIMD3<Double> = [0, 0, 0],
        angularSpeedVariation: SIMD3<Double> = [0, 0, 0],
        colors: ColorMode = .single(.white),
        size: Double = 1,
        sizeVariation: Double = 0,
        sizeMultiplierAtDeath: Double = 1,
        stretchFactor: Double = 1
    ) {
        self.secondarySystems = secondarySystems
        self.vortexSettings = Settings(
            tags: tags,
            spawnOccasion: spawnOccasion,
            position: position,
            shape: shape,
            birthRate: birthRate,
            emissionLimit: emissionLimit,
            emissionDuration: emissionDuration,
            idleDuration: idleDuration,
            burstCount: burstCount,
            burstCountVariation: burstCountVariation,
            lifespan: lifespan,
            lifespanVariation: lifespanVariation,
            speed: speed,
            speedVariation: speedVariation,
            angle: angle,
            angleRange: angleRange,
            acceleration: acceleration,
            attractionCenter: attractionCenter,
            attractionStrength: attractionStrength,
            dampingFactor: dampingFactor,
            angularSpeed: angularSpeed,
            angularSpeedVariation: angularSpeed,
            colors: colors,
            size: size,
            sizeVariation: sizeVariation,
            sizeMultiplierAtDeath: sizeMultiplierAtDeath,
            stretchFactor: stretchFactor
        )

        if case .randomRamp(let allColors) = colors {
            selectedColorRamp = Int.random(in: 0..<allColors.count)
        }
    }

    /// Because particle systems are classes rather than structs, we need to make deep
    /// copies by hand. This is important when creating a secondary system. This method
    /// copies all values across.
    @available(*, deprecated, message: "Initialise your VortexSystem with the `settings:` parameter, and this call is no longer needed. ")
    public func makeUniqueCopy() -> VortexSystem {
        VortexSystem(
            tags: vortexSettings.tags,
            secondarySystems: secondarySystems,
            spawnOccasion: vortexSettings.spawnOccasion,
            position: vortexSettings.position,
            shape: vortexSettings.shape,
            birthRate: vortexSettings.birthRate,
            emissionLimit: vortexSettings.emissionLimit,
            emissionDuration: vortexSettings.emissionDuration,
            idleDuration: vortexSettings.idleDuration,
            burstCount: vortexSettings.burstCount,
            burstCountVariation: vortexSettings.burstCountVariation,
            lifespan: vortexSettings.lifespan,
            lifespanVariation: vortexSettings.lifespanVariation,
            speed: vortexSettings.speed,
            speedVariation: vortexSettings.speedVariation,
            angle: vortexSettings.angle,
            angleRange: vortexSettings.angleRange,
            acceleration: vortexSettings.acceleration,
            attractionCenter: vortexSettings.attractionCenter,
            attractionStrength: vortexSettings.attractionStrength,
            dampingFactor: vortexSettings.dampingFactor,
            angularSpeed: vortexSettings.angularSpeed,
            angularSpeedVariation: vortexSettings.angularSpeedVariation,
            colors: vortexSettings.colors,
            size: vortexSettings.size,
            sizeVariation: vortexSettings.sizeVariation,
            sizeMultiplierAtDeath: vortexSettings.sizeMultiplierAtDeath,
            stretchFactor: vortexSettings.stretchFactor
        )
    }
}
