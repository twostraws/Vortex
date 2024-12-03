//
// VortexSystem-Behavior.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

/// All the VortexSystem methods responsible for managing a live particle system.
extension VortexSystem {
    /// The primary method for updating the particle system. This should be called from a
    /// SwiftUI `TimelineView` every time it updates.
    /// - Parameters:
    ///   - date: The current date.
    ///   - drawSize: The size of the space we're drawing into.
    func update(date: Date, drawSize: CGSize) {
        lastDrawSize = drawSize
        updateSecondarySystems(date: date, drawSize: drawSize)

        let drawDivisor = drawSize.height / drawSize.width
        let currentTimeInterval = date.timeIntervalSince1970

        let delta = currentTimeInterval - lastUpdate
        lastUpdate = currentTimeInterval

        if vortexSettings.isEmitting && lastUpdate - lastIdleTime > vortexSettings.emissionDuration {
            vortexSettings.isEmitting = false
            lastIdleTime = lastUpdate
        } else if vortexSettings.isEmitting == false && lastUpdate - lastIdleTime > vortexSettings.idleDuration {
            vortexSettings.isEmitting = true
            lastIdleTime = lastUpdate
        }

        createParticles(delta: delta)

        var attractionUnitPoint: SIMD2<Double>?

        // Push attraction strength down to a small number, otherwise
        // it's much too strong.
        let adjustedAttractionStrength = vortexSettings.attractionStrength / 1000

        if let attractionCenter = vortexSettings.attractionCenter {
            attractionUnitPoint = [attractionCenter.x / drawSize.width, attractionCenter.y / drawSize.height]
        }

        particles = particles.compactMap {
            var particle = $0
            let age = currentTimeInterval - particle.birthTime
            let lifeProgress = age / particle.lifespan

            // Apply attraction force to particle's existing velocity.
            if let attractionUnitPoint {
                let gap = attractionUnitPoint - particle.position
                let distance = sqrt((gap * gap).sum())

                if distance > 0 {
                    let normalized = gap / distance

                    // Increase the magnitude the closer we get, adding a small
                    // amount to avoid a slingshot / over-attraction.
                    let movementMagnitude = adjustedAttractionStrength / (distance * distance + 0.0025)
                    let movement = normalized * movementMagnitude * delta
                    particle.position += movement
                }
            }

            // Update particle position
            particle.position.x += particle.speed.x * delta * drawDivisor
            particle.position.y += particle.speed.y * delta

            if vortexSettings.dampingFactor != 1 {
                let dampingAmount = vortexSettings.dampingFactor * delta / vortexSettings.lifespan
                particle.speed -= particle.speed * dampingAmount
            }

            particle.speed += vortexSettings.acceleration * delta
            particle.angle += particle.angularSpeed * delta

            particle.currentColor = particle.colors.lerp(by: lifeProgress)

            particle.currentSize = particle.initialSize.lerp(
                to: particle.initialSize * vortexSettings.sizeMultiplierAtDeath,
                amount: lifeProgress
            )

            if age >= particle.lifespan {
                spawn(from: particle, event: .onDeath)
                return nil
            } else {
                spawn(from: particle, event: .onUpdate)
                return particle
            }
        }
    }

    /// Create particles that should have been created between now and the last update time. (delta)
    /// Note that the birthrate can be fractional, e.g. 0.2, to generate a particle every 5 seconds,
    /// so keeping track of fractional outstanding particles is necessary
    private func createParticles(delta: Double) {
        outstandingParticles += vortexSettings.birthRate * delta

        if outstandingParticles >= 1 {
            let particlesToCreate = Int(outstandingParticles)

            for _ in 0..<particlesToCreate {
                createParticle()
            }

            outstandingParticles -= Double(particlesToCreate)
        }
    }

    /// Update each secondary system, and remove those that have expired.
    private func updateSecondarySystems(date: Date, drawSize: CGSize) {
        for activeSecondarySystem in activeSecondarySystems {
            activeSecondarySystem.update(date: date, drawSize: drawSize)
            // If a system has emitted particles, but currently has none, remove it.
            if activeSecondarySystem.particles.isEmpty && activeSecondarySystem.emissionCount > 0 {
                activeSecondarySystems.remove(activeSecondarySystem)
            }
        }
    }

    /// Used to create a single particle.
    /// - Parameter force: When true, this will create a particle even if
    /// this system has already reached its emission limit.
    func createParticle(force: Bool = false) {
        guard vortexSettings.isEmitting else { return }

        if let emissionLimit = vortexSettings.emissionLimit {
            if emissionCount >= emissionLimit && force == false {
                return
            }
        }

        // We subtract half of pi here to ensure that angle 0 is directly up.
        let launchAngle = vortexSettings.angle.radians + vortexSettings.angleRange.radians.randomSpread() - .pi / 2
        let launchSpeed = vortexSettings.speed + vortexSettings.speedVariation.randomSpread()
        let lifespan = vortexSettings.lifespan + vortexSettings.lifespanVariation.randomSpread()
        let size = vortexSettings.size + vortexSettings.sizeVariation.randomSpread()
        let particlePosition = getNewParticlePosition()

        let speed = SIMD2(
            cos(launchAngle) * launchSpeed,
            sin(launchAngle) * launchSpeed
        )

        let spinSpeed = vortexSettings.angularSpeed + vortexSettings.angularSpeedVariation.randomSpread()
        let colorRamp = getNewParticleColorRamp()

        let newParticle = Particle(
            tag: vortexSettings.tags.randomElement() ?? "",
            position: particlePosition,
            speed: speed,
            birthTime: lastUpdate,
            lifespan: lifespan,
            initialSize: size,
            angularSpeed: spinSpeed,
            colors: colorRamp
        )

        particles.append(newParticle)
        spawn(from: newParticle, event: .onBirth)
        emissionCount += 1
    }

    /// Force a bunch of particles to be created immediately.
    func burst() {
        let particlesToCreate = vortexSettings.burstCount + vortexSettings.burstCountVariation.randomSpread()

        for _ in 0..<particlesToCreate {
            createParticle(force: true)
        }
    }

    /// Finds and creates any appropriate secondary systems for this particle.
    func spawn(from particle: Particle, event: SpawnOccasion) {
        let secondarySettings = vortexSettings.secondarySettings.filter {
            $0.spawnOccasion == event
        }
        for secondarySetting in secondarySettings {
            let secondarySystem = VortexSystem(secondarySetting)
            secondarySystem.vortexSettings.position = particle.position
            activeSecondarySystems.insert(secondarySystem)
        }
    }

    /// Calculate a starting position for a new particle, based on the `shape` configuration setting.
    func getNewParticlePosition() -> SIMD2<Double> {
        switch vortexSettings.shape {
        case .point:
                return vortexSettings.position

        case .box(let width, let height):
            return [
                vortexSettings.position.x + width.randomSpread(),
                vortexSettings.position.y + height.randomSpread()
            ]

        case .ellipse(let radius):
            let angle = Double.random(in: 0...(2 * .pi))
            let placement = Double.random(in: 0...radius / 2)

            return [
                placement * cos(angle) + vortexSettings.position.x,
                placement * sin(angle) + vortexSettings.position.y
            ]

        case .ring(let radius):
            let angle = Double.random(in: 0...(2 * .pi))
            let placement = radius / 2
            return [
                placement * cos(angle) + vortexSettings.position.x,
                placement * sin(angle) + vortexSettings.position.y
            ]
        }
    }

    func getNewParticleColorRamp() -> [Color] {
        switch vortexSettings.colors {
        case .single(let color):
            return [color]

        case .random(let colors):
            if let randomColor = colors.randomElement() {
                return [randomColor]
            } else {
                return [.white]
            }

        case .ramp(let colors):
            return colors

        case .randomRamp(let colors):
            return colors[vortexSettings.selectedColorRamp]
        }
    }
}
