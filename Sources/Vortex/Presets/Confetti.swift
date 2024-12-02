//
// Confetti.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

//extension VortexSystem {
//    /// A built-in effect that creates confetti only when a burst is triggered.
//    /// Relies on "triangle" and "circle" tags being present – using `Rectangle`
//    /// and `Circle` with frames of 16x16 works well.
//    public static let confetti: VortexSystem = VortexSystem(.confetti) 
//}

extension VortexSystem.Settings {
    /// These settings create confetti (only) when a burst is triggered.
    /// Relies on "square" and "circle" tags being present – using `Rectangle`
    /// and `Circle` with frames of 16x16 works well.
    public static let confetti = VortexSystem.Settings {settings in
        settings.tags = ["triangle", "circle"]
        settings.birthRate = 0
        settings.lifespan = 4
        settings.speed = 0.5
        settings.speedVariation = 0.5
        settings.angleRange = .degrees(90)
        settings.acceleration = [0, 1]
        settings.angularSpeedVariation = [4, 4, 4]
        settings.colors = .random(.white, .red, .green, .blue, .pink, .orange, .cyan)
        settings.size = 0.5
        settings.sizeVariation = 0.5
    }
}

#Preview("Confetti") {
    VortexViewReader { proxy in
        ZStack {
            Text("Tap anywhere to create confetti.")
            
            VortexView(.confetti) 
                .gesture( 
                    /// Drag gesture is available on all platforms vs onTap which requires macOS 14+
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            proxy.move(to: gesture.location)
                            proxy.burst()
                        }
                )
        }
    }
    .navigationSubtitle("Demonstrates on-demand particle bursting")
    .ignoresSafeArea(edges: .top)
}

