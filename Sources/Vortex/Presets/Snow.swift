//
// Snow.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A built-in snow effect. Relies on a "circle" tag being present.
    public static let snow: VortexSystem = VortexSystem(.snow)
}
extension VortexSystem.Settings {
    static let snow = VortexSystem.Settings { settings in
        settings.tags = ["circle"]
        settings.position = [0.5, 0]
        settings.shape = .box(width: 1, height: 0)
        settings.birthRate = 50
        settings.lifespan = 10
        settings.speed = 0.2
        settings.speedVariation = 0.2
        settings.angle = .degrees(180)
        settings.angleRange = .degrees(20)
        settings.size = 0.25
        settings.sizeVariation = 0.4 
    }
}

#Preview {
    VortexView(.snow)
        .frame(width: 500, height: 500)
}
