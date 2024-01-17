//
// VortexView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// A SwiftUI view that renders a Vortex particle system.
public struct VortexView<Symbols>: View where Symbols: View {
    /// The list of SwiftUI views that should be used to draw particles.
    @ViewBuilder var symbols: Symbols

    /// The primary system this is responsible for drawing.
    @State private var particleSystem: VortexSystem

    /// The ideal frame rate for updating particles. Using lower frame rates saves CPU time.
    public var targetFrameRate: Int

    public var body: some View {
        TimelineView(.animation(minimumInterval: 1 / Double(targetFrameRate))) { timeline in
            Canvas { context, size in
                particleSystem.update(date: timeline.date, drawSize: size)
                draw(particleSystem, into: context, at: size)
            } symbols: {
                symbols
            }
        }
        .preference(key: VortexSystemPreferenceKey.self, value: particleSystem)
    }

    /// Creates a new VortexView from a pre-configured particle system, along with all the SwiftUI
    /// views to render as particles.
    /// - Parameters:
    ///   - system: The primary particle system you want to render.
    ///   - symbols: A list of SwiftUI views to use as particles.
    public init(_ system: VortexSystem, targetFrameRate: Int = 60, @ViewBuilder symbols: () -> Symbols) {
        _particleSystem = State(initialValue: system)
        self.targetFrameRate = targetFrameRate
        self.symbols = symbols()
    }

    /// Draws one particle system inside the canvas.
    /// - Parameters:
    ///   - particleSystem: The particle system to draw.
    ///   - context: The drawing context we're rendering into.
    ///   - size: The size of the space we're rendering into.
    private func draw(_ particleSystem: VortexSystem, into context: GraphicsContext, at size: CGSize) {
        for particle in particleSystem.particles {
            // Find the appropriate tag for this particle.
            guard let symbol = context.resolveSymbol(id: particle.tag) else {
                print("VortexView: Unable to locate symbol named \(particle.tag).")
                continue
            }

            // Calculate position in screen space.
            let xPos = particle.position.x * size.width
            let yPos = particle.position.y * size.height

            // Bail out early if this particle has moved off the screen.
            // This largely seems to avoid an annoying SwiftUI render
            // error: "Invalid view geometry: height is negative."
            if yPos <= -symbol.size.height { continue }
            if yPos >= size.height + symbol.size.height { continue }

            // Apply basic properties.
            var contextCopy = context
            contextCopy.addFilter(.colorMultiply(particle.currentColor.renderColor))
            contextCopy.opacity = particle.currentColor.opacity
            contextCopy.translateBy(x: xPos, y: yPos)
            contextCopy.scaleBy(x: particle.currentSize, y: particle.currentSize)

            // Apply rotation. watchOS does not support 3D rotations, so
            // we fall back to 2D.
            #if os(watchOS)
            contextCopy.rotate(by: .radians(particle.angle.z))
            #else
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, particle.angle.x, 1, 0, 0)
            transform = CATransform3DRotate(transform, particle.angle.y, 0, 1, 0)
            transform = CATransform3DRotate(transform, particle.angle.z, 0, 0, 1)
            contextCopy.addFilter(.projectionTransform(ProjectionTransform(transform)))
            #endif

            // Apply stretch factor.
            if particleSystem.stretchFactor != 1 {
                let velocityMagnitude = sqrt(particle.speed.x * particle.speed.x + particle.speed.y * particle.speed.y)
                let stretch = max(1.0, velocityMagnitude * particleSystem.stretchFactor)
                let stretchDirection = atan2(particle.speed.y, particle.speed.x)
                contextCopy.rotate(by: .radians(stretchDirection + .pi / 2))
                contextCopy.scaleBy(x: 1, y: stretch)
            }

            // Now render the particle.
            contextCopy.draw(symbol, at: .zero)
        }

        // Now we've finished drawing ourselves, recursively draw
        // all secondary systems.
        for secondarySystem in particleSystem.activeSecondarySystems {
            draw(secondarySystem, into: context, at: size)
        }
    }
}
