//
// Fireflies.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in firefly effect. Relies on a "circle" tag being present, which should be set to use
    /// `.blendMode(.plusLighter)`.
    public static let fireflies: VortexSettings = {
        VortexSettings(
            tags: ["circle"],
            shape: .ellipse(radius: 0.5),
            birthRate: 200,
            lifespan: 2,
            speed: 0,
            speedVariation: 0.25,
            angleRange: .degrees(360),
            colors: .ramp(.yellow, .yellow, .yellow.opacity(0)),
            size: 0.01,
            sizeMultiplierAtDeath: 100
        )
    }()
}

/// A Fireflies preview, using the `.fireflies` preset
/// macOS 15 is required for the `.onModifierKeysChanged` method that is used to capture the Option key being pressed.
@available(macOS 15.0, *)
#Preview("Fireflies") {
    @Previewable @State var isDragging = false
    /// A state value indicating whether the Option key is being held down
    @Previewable @State var pressingOptionKey = false
    VortexViewReader { proxy in
        ZStack(alignment: .bottom) {
            let instructions = if isDragging {
                "Release your drag to reset the fireflies."
            } else if !pressingOptionKey {
                "Drag anywhere to repel the fireflies. Or hold the Option Key"
            } else {
                "Drag anywhere to attract the fireflies"
            }
            
            Text(instructions)
                .padding(.bottom, 20)
            
            VortexView(.fireflies) {
                Circle()
                    .fill(.white)
                    .frame(width: 32)
                    .blur(radius: 3)
                    .blendMode(.plusLighter)
                    .tag("circle")
            }
                .onModifierKeysChanged(mask: .option) { _, new in
                    // set the view state based on whether the 
                    // `new` EventModifiers value contains a value (that would be the option key)
                    pressingOptionKey = !new.isEmpty
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            proxy.attractTo(value.location)
                            proxy.particleSystem?
                                .attractionStrength = pressingOptionKey ? 2.5 : -2
                            isDragging = true
                        }
                        .onEnded { _ in
                            proxy.particleSystem?
                                .attractionStrength = 0
                            isDragging = false
                        }
                )
        }
    }
    .navigationSubtitle("Demonstrates use of attraction and repulsion")
    .ignoresSafeArea(edges: .top)
}
