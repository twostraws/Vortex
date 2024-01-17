//
// Rain.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in rain effect. Relies on a "circle" tag being present.
    public static let rain: VortexSystem = {
        VortexSystem(
            tags: ["circle"],
            position: [0.5, 0 ],
            shape: .box(width: 1.8, height: 0),
            birthRate: 400,
            lifespan: 0.5,
            speed: 4.5,
            speedVariation: 2,
            angle: .degrees(190),
            colors: .random(
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.6),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.5),
                Color(red: 0.7, green: 0.7, blue: 1, opacity: 0.4)
            ),
            size: 0.09,
            sizeVariation: 0.05,
            stretchFactor: 12
        )
    }()
}
