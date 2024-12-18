//
// Snow.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSettings {
    /// A built-in snow effect. Relies on a "circle" tag being present.
    public static let snow: VortexSettings = {
        VortexSettings(
            tags: ["circle"],
            position: [0.5, 0],
            shape: .box(width: 1, height: 0),
            birthRate: 50,
            lifespan: 10,
            speed: 0.2,
            speedVariation: 0.2,
            angle: .degrees(180),
            angleRange: .degrees(20),
            size: 0.25,
            sizeVariation: 0.4
        )
    }()
}

#Preview {
    // Use the snow preset, using the default symbol for the circle tag
    VortexView(.snow){
        Circle()
            .fill(.white)
            .frame(width: 24)
            .blur(radius: 5)
            .tag("circle")
    }
}
