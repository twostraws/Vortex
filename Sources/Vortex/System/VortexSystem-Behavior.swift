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
        
        if settings.isEmitting && lastUpdate - lastIdleTime > settings.emissionDuration {
            settings.isEmitting = false
            lastIdleTime = lastUpdate
        } else if settings.isEmitting == false && lastUpdate - lastIdleTime > settings.idleDuration {
            settings.isEmitting = true
            lastIdleTime = lastUpdate
        }
        
        createParticles(delta: delta)
        
        var attractionUnitPoint: SIMD2<Double>?
        
        // Push attraction strength down to a small number, otherwise
        // it's much too strong.
        let adjustedAttractionStrength = settings.attractionStrength / 1000
        
        if let attractionCenter = settings.attractionCenter {
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
            
            if settings.dampingFactor != 1 {
                let dampingAmount = settings.dampingFactor * delta / settings.lifespan
                particle.speed -= particle.speed * dampingAmount
            }
            
            particle.speed += settings.acceleration * delta
            particle.angle += particle.angularSpeed * delta
            
            particle.currentColor = particle.colors.lerp(by: lifeProgress)
            
            particle.currentSize = particle.initialSize.lerp(
                to: particle.initialSize * settings.sizeMultiplierAtDeath,
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
    
    private func createParticles(delta: Double) {
        outstandingParticles += settings.birthRate * delta
        
        if outstandingParticles >= 1 {
            let particlesToCreate = Int(outstandingParticles)
            
            for _ in 0..<particlesToCreate {
                createParticle()
            }
            
            outstandingParticles -= Double(particlesToCreate)
        }
    }
    
    private func updateSecondarySystems(date: Date, drawSize: CGSize) {
        for activeSecondarySystem in activeSecondarySystems {
            activeSecondarySystem.update(date: date, drawSize: drawSize)
            
            if activeSecondarySystem.particles.isEmpty && activeSecondarySystem.emissionCount > 0 {
                activeSecondarySystems.remove(activeSecondarySystem)
            }
        }
    }
    
    /// Used to create a single particle.
    /// - Parameter force: When true, this will create a particle even if
    /// this system has already reached its emission limit.
    func createParticle(force: Bool = false) {
        guard settings.isEmitting, 
              emissionCount < settings.emissionLimit ?? Int.max || force == true 
        else { return }
        
        // We subtract half of pi here to ensure that angle 0 is directly up.
        let launchAngle = settings.angle.radians + settings.angleRange.radians.randomSpread() - .pi / 2
        let launchSpeed = settings.speed + settings.speedVariation.randomSpread()
        let lifespan = settings.lifespan + settings.lifespanVariation.randomSpread()
        let size = settings.size + settings.sizeVariation.randomSpread()
        let particlePosition = getNewParticlePosition()

        let speed = SIMD2(
            cos(launchAngle) * launchSpeed,
            sin(launchAngle) * launchSpeed
        )

        let spinSpeed = settings.angularSpeed + settings.angularSpeedVariation.randomSpread()
        let colorRamp = getNewParticleColorRamp()

        let newParticle = Particle(
            tag: settings.tags.randomElement() ?? "",
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
        let particlesToCreate = settings.burstCount + settings.burstCountVariation.randomSpread()

        for _ in 0..<particlesToCreate {
            createParticle(force: true)
        }
    }

    /// Finds and creates any appropriate secondary systems for this particle.
    func spawn(from particle: Particle, event: SpawnOccasion) {
        /// Check secondary settings for a new system that should be spawned
        let matchedSettings = settings.secondarySettings.filter { $0.spawnOccasion == event }
        for settings in matchedSettings {
            let newSystem = VortexSystem(settings)
            newSystem.settings.position = particle.position
            activeSecondarySystems.insert(newSystem)
        }
    }

    func getNewParticlePosition() -> SIMD2<Double> {
        switch settings.shape {
        case .point:
                return settings.position

        case .box(let width, let height):
            return [
                settings.position.x + width.randomSpread(),
                settings.position.y + height.randomSpread()
            ]

        case .ellipse(let radius):
            let angle = Double.random(in: 0...(2 * .pi))
            let placement = Double.random(in: 0...radius / 2)

            return [
                placement * cos(angle) + settings.position.x,
                placement * sin(angle) + settings.position.y
            ]

        case .ring(let radius):
            let angle = Double.random(in: 0...(2 * .pi))

            return [
                radius / 2 * cos(angle) + settings.position.x,
                radius / 2 * sin(angle) + settings.position.y
            ]
        }
    }

    func getNewParticleColorRamp() -> [Color] {
        switch settings.colors {
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
            return colors[selectedColorRamp]
        }
    }
}
