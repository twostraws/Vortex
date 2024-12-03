//
// Fireflies.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in firefly effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let fireflies: VortexSystem = .init(.fireflies)
}
extension VortexSystem.Settings {
    ///Built in settings for a firefly effect.
    public static let fireflies = VortexSystem.Settings { settings in
        settings.tags = ["circle"]
        settings.shape = .ellipse(radius: 0.5)
        settings.birthRate = 200
        settings.lifespan = 2
        settings.speed = 0
        settings.speedVariation = 0.25
        settings.angleRange = .degrees(360)
        settings.colors = .ramp(.yellow, .yellow, .yellow.opacity(0))
        settings.size = 0.01
        settings.sizeMultiplierAtDeath = 100
    }
}

@available(macOS 15.0, *)
#Preview("Fireflies") {
    @Previewable @State var isDragging = false
    /// A state value indicating whether the Option key is being held down
    @Previewable @State var pressingOptionKey = false
    VortexViewReader { proxy in
        ZStack(alignment: .bottom) {
            if isDragging {
                Text("Release your drag to reset the fireflies.")
                    .padding(.bottom, 20)
            } else {
                let instructions = if !pressingOptionKey {
                    "Drag anywhere to repel the fireflies. Or hold the Option Key"
                } else {
                    "Drag anywhere to attract the fireflies"
                }
                Text(instructions)
                    .padding(.bottom, 20)
            }

            VortexView(.fireflies) 
                .onModifierKeysChanged(mask: .option) { _, new in
                    // set the view state based whether the 
                    // `new` EventModifiers value contains the option key
                    pressingOptionKey = !new.isEmpty
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            proxy.attractTo(value.location)
                            proxy.particleSystem?.vortexSettings
                                .attractionStrength = pressingOptionKey ? 2.5 : -2
                            isDragging = true
                        }
                        .onEnded { _ in
                            proxy.particleSystem?.vortexSettings
                                .attractionStrength = 0
                            isDragging = false
                        }
                )
        }
    }
    .navigationSubtitle("Demonstrates use of attraction and repulsion")
    .ignoresSafeArea(edges: .top)
}
