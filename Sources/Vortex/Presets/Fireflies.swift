//
// Fireflies.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {  
    /// A built-in firefly effect. Uses the built-in 'circle' image.
    public static let fireflies = VortexSettings() { settings in 
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

/// A Fireflies preview, using the `.fireflies` preset
/// macOS 15 is required for the `.onModifierKeysChanged` method that is used to capture the Option key being pressed.
@available(macOS 15.0, *)
#Preview("Demonstrates use of attraction and repulsion") {
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
                        proxy.particleSystem?.settings.attractionStrength = pressingOptionKey ? 2.5 : -2
                        isDragging = true
                    }
                    .onEnded { _ in
                        proxy.particleSystem?.settings.attractionStrength = 0
                        isDragging = false
                    }
            )
        }
    }
}
