//
// VortexSystem.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// The main particle system generator class that powers Vortex.
public class VortexSystem: Codable, Identifiable, Equatable, Hashable {
    /// The subset of properties we need to load and save to handle Codable correctly.
    enum CodingKeys: CodingKey {
        case tags, secondarySystems, spawnOccasion, position, shape, birthRate, emissionLimit, emissionDuration
        case idleDuration, burstCount, burstCountVariation, lifespan, lifespanVariation, speed, speedVariation, angle
        case angleRange, acceleration, attractionCenter, attractionStrength, dampingFactor, angularSpeed
        case angularSpeedVariation, colors, size, sizeVariation, sizeMultiplierAtDeath, stretchFactor
    }

    /// A random identifier that lets us create Equatable and Hashable conformances easily.
    public let id = UUID()

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
    /// The current position of this particle system, in unit space.
    public var position: SIMD2<Double>

    /// The list of possible tags to use for this particle system. This might be the full set of
    /// tags passed into a `VortexView`, but might also be a subset if secondary systems
    /// use other tags.
    public var tags = [String]()

    /// Whether this particle system should actively be emitting right now.
    public var isEmitting = true

    /// The list of secondary systems that can be created by this system.
    public var secondarySystems = [VortexSystem]()

    /// When this particle system should be spawned. This is useful only for secondary systems.
    public var spawnOccasion: SpawnOccasion

    // These properties control how particles are created.
    /// The shape of this particle system, which controls where particles are created relative to
    /// the system's position.
    public var shape: Shape

    /// How many particles are created every second. You can use values below 1 here, e.g
    /// a birth rate of 0.2 means one particle being created every 5 seconds.
    public var birthRate: Double

    /// The total number of particles this system should create. A value of `nil` means no limit.
    public var emissionLimit: Int?

    /// How long this system should emit particles for before pausing, measured in seconds.
    public var emissionDuration: TimeInterval

    /// How long this system should wait between particle emissions, measured in seconds.
    public var idleDuration: TimeInterval

    /// How many particles should be emitted when a burst is requested.
    public var burstCount: Int

    /// How much variation should be allowed in bursts.
    public var burstCountVariation: Int

    /// How long particles should live for, measured in seconds.
    public var lifespan: TimeInterval

    /// How much variation to allow in particle lifespan.
    public var lifespanVariation: TimeInterval

    // These properties control how particles move.
    /// The base rate of movement for particles. A speed of 1 means the system will move
    /// from one side to the other in one second.
    public var speed: Double

    /// How much variation to allow in particle speed.
    public var speedVariation: Double

    /// The base direction to launch new particles, where 0 is directly up.
    public var angle: Angle

    /// How much variation to use in particle launch direction.
    public var angleRange: Angle

    /// How much acceleration to apply for particle movement. Set to 0 by default, meaning
    /// that no acceleration is applied.
    public var acceleration: SIMD2<Double>

    /// A specific point particles should move towards or away from, based
    /// on `attractionStrength`. A `nil` value here means no attraction.
    public var attractionCenter: SIMD2<Double>?

    /// How fast to move towards `attractionCenter`, when it is not `nil`.
    public var attractionStrength: Double

    /// How fast movement speed should be slowed down.
    public var dampingFactor: Double

    /// How fast particles should spin.
    public var angularSpeed: SIMD3<Double>

    /// How much variation to allow in particle spin speed.
    public var angularSpeedVariation: SIMD3<Double>

    // These properties determine how particles are drawn.
    /// What colors to use for particles made by this system. If `randomRamp` is used
    /// then this system picks one possible color ramp to use.
    public var colors: ColorMode {
        didSet {
            if case let .randomRamp(allColors) = colors {
                self.selectedColorRamp = Int.random(in: 0..<allColors.count)
            }
        }
    }

    /// How large particles should be drawn, where a value of 1 means 100% the image size.
    public var size: Double

    /// How much variation to use for particle size.
    public var sizeVariation: Double

    /// How how much bigger or smaller this particle should be by the time it is removed.
    /// This is used as a multiplier based on the particle's initial size, so if it starts at size
    /// 0.5 and has a `sizeMultiplierAtDeath` of 0.5, the particle will finish
    /// at size 0.25.
    public var sizeMultiplierAtDeath: Double

    /// How much to stretch this particle's image based on its movement speed. Larger values
    /// cause more stretching.
    public var stretchFactor: Double

    /// Creates a new particle system. Most values here have sensible defaults, but you do need
    /// to provide a list of tags matching whatever you're using with `VortexView`.
    /// - Parameters:
    ///   - tags: The list of possible tags to use for this particle system. This might be the
    ///     full set of tags passed into a `VortexView`, but might also be a subset if
    ///     secondary systems use other tags.
    ///   - secondarySystems: The list of secondary systems that can be created
    ///     by this system. Defaults to an empty array.
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
        self.tags = tags
        self.secondarySystems = secondarySystems
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

        if case let .randomRamp(allColors) = colors {
            selectedColorRamp = Int.random(in: 0..<allColors.count)
        }
    }

    /// Two particle systems are the same if they they have same identifier.
    public static func == (lhs: VortexSystem, rhs: VortexSystem) -> Bool {
        lhs.id == rhs.id
    }

    /// The hash value for this system is simply its identifier.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Because particle systems are classes rather than structs, we need to make deep
    /// copies by hand. This is important when creating a secondary system. This method
    /// copies all values across.
    public func makeUniqueCopy() -> VortexSystem {
        VortexSystem(
            tags: tags,
            secondarySystems: secondarySystems,
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
            angularSpeedVariation: angularSpeedVariation,
            colors: colors,
            size: size,
            sizeVariation: sizeVariation,
            sizeMultiplierAtDeath: sizeMultiplierAtDeath,
            stretchFactor: stretchFactor
        )
    }
}
