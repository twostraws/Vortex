//
// Settings.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

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
public struct VortexSettings: Equatable, Hashable, Identifiable, Codable {
    /// Unique id. Set as variable to allow decodable conformance without compiler quibbles.
    public var id: UUID = UUID()

    /// Equatable conformance
    public static func == ( lhs: VortexSettings, rhs: VortexSettings ) -> Bool {
        lhs.id == rhs.id
    }
    /// Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

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
    /// Defaults to true
    public var isEmitting = true

    /// The list of secondary settings associated with this setting. Empty by default.
    public var secondarySettings = [VortexSettings]()

    /// When this particle system should be spawned. This is useful only for secondary systems.
    /// Defaults to `.onBirth`
    public var spawnOccasion: VortexSystem.SpawnOccasion = .onBirth

    // These properties control how particles are created.
    /// The shape of this particle system, which controls where particles are created relative to
    /// the system's position.
    /// Defaults to `.point`
    public var shape: VortexSystem.Shape = .point

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
    public var burstCountVariation: Int = .zero

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
    public var acceleration: SIMD2<Double> = [0, 0]

    /// A specific point particles should move towards or away from, based
    /// on `attractionStrength`. A `nil` value here means no attraction.
    public var attractionCenter: SIMD2<Double>? = nil

    /// How fast to move towards `attractionCenter`, when it is not `nil`.
    /// Defaults to 0
    public var attractionStrength: Double = .zero

    /// How fast movement speed should be slowed down.
    /// Defaults to 0
    public var dampingFactor: Double = .zero

    /// How fast particles should spin.
    /// Defaults to zero
    public var angularSpeed: SIMD3<Double> = [0, 0, 0]

    /// How much variation to allow in particle spin speed.
    /// Defaults to zero
    public var angularSpeedVariation: SIMD3<Double> = [0, 0, 0]

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
    /// then the VortexSystem initialiser will pick one possible color ramp to use.
    /// A single, white, color is used by default.
    public var colors: VortexSystem.ColorMode = .single(.white)

    /// VortexSettings initialisation.
    /// - Parameters: None. Uses sensible default values on initialisation, with no parameters required.
    public init() {}

    /// Convenient init for VortexSettings initialisation.  Allows initialisation based on an existing settings struct, copies it into a new struct and modifiiesf it via a supplied closure
    /// - Parameters:
    ///  - basedOn: `VortexSettings`
    ///  The base settings struct to be used as a base. Defaullt settings will be used if not supplied.
    ///  - : @escaping (inout VortexSettings)->Void
    ///  An anonymous closure which will modify the settings supplied in the first parameter
    /// e.g.
    /// ```swift
    /// let newFireSettings = VortexSettings(from: .fire ) 
    /// ```
    public init(
        basedOn base: VortexSettings = VortexSettings(),
        _ modifiedBy: @escaping (_: inout VortexSettings) -> Void = {_ in}
    ) {
        // Take a copy of the base struct, and generate new id
        var newSettings = base
        newSettings.id = UUID()
        // Amend newSettings by calling the supplied closure
        modifiedBy(&newSettings)
        self = newSettings
    }

    /// Formerly used within VortexSystem to make deep copies of the VortexSystem class so that secondary systems functioned correctly.
    /// No longer needed, but created here for backward compatibility
    @available(*, deprecated, message: "Deprecated. This method is no longer required")
    public func makeUniqueCopy() -> VortexSettings {
        return self
    }

    /// Backward compatibility again, for those converting from the old VortexSystem initialiser
    public init(
        tags: [String],
        spawnOccasion: VortexSystem.SpawnOccasion = .onBirth,
        position: SIMD2<Double> = [0.5, 0.5],
        shape: VortexSystem.Shape = .point,
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
        colors: VortexSystem.ColorMode = .single(.white),
        size: Double = 1,
        sizeVariation: Double = 0,
        sizeMultiplierAtDeath: Double = 1,
        stretchFactor: Double = 1
    ) {
        id = UUID()
        self.tags = tags
        self.spawnOccasion = spawnOccasion
        self.position = position
        self.shape = shape
        self.birthRate = birthRate
        self.emissionLimit = emissionLimit
        self.emissionDuration = emissionDuration
        self.idleDuration = idleDuration
        self.burstCount = burstCount
        self.burstCountVariation = burstCountVariation
        self.lifespan = lifespan
        self.lifespanVariation = lifespanVariation
        self.speed = speed
        self.speedVariation = speedVariation
        self.angle = angle
        self.acceleration = acceleration
        self.angleRange = angleRange
        self.attractionCenter = attractionCenter
        self.attractionStrength = attractionStrength
        self.dampingFactor = dampingFactor
        self.angularSpeed = angularSpeed
        self.angularSpeedVariation = angularSpeedVariation
        self.colors = colors
        self.size = size
        self.sizeVariation = sizeVariation
        self.sizeMultiplierAtDeath = sizeMultiplierAtDeath
        self.stretchFactor = stretchFactor
    }
}