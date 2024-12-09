//
// Confetti.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in effect that creates confetti only when a burst is triggered.
    public static let confetti = VortexSettings { settings in
        settings.tags = ["square", "circle"]
        settings.birthRate = 0
        settings.lifespan = 4
        settings.speed = 0.5
        settings.speedVariation = 0.5
        settings.angleRange = .degrees(90)
        settings.acceleration = [0, 1]
        settings.angularSpeedVariation = [4, 4, 4]
        settings.colors = .random(
            .white, .red, .green, .blue, .pink, .orange, .cyan)
        settings.size = 0.5
        settings.sizeVariation = 0.5
    }
}

@available(macOS 14.0, *) 
#Preview("Demonstrate on demand bursts") {
    VortexViewReader { proxy in
        ZStack {
            Text("Tap anywhere to create confetti.")
            
            VortexView(.confetti.makeUniqueCopy()) {
                Rectangle()
                    .fill(.white)
                    .frame(width: 16, height: 16)
                    .tag("square")
                Circle()
                    .fill(.white)
                    .frame(width: 16)
                    .tag("circle")
            }
            .onTapGesture { location in
                proxy.move(to: location)
                proxy.burst()
            }
        }
    }
}

