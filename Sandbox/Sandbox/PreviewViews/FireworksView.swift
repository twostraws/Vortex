//
// FireworksView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating the built-in fireworks preset.
struct FireworksView: View {
    var body: some View {
        VortexView(.fireworks.makeUniqueCopy()) {
            Circle()
                .fill(.white)
                .frame(width: 32)
                .blur(radius: 5)
                .blendMode(.plusLighter)
                .tag("circle")
        }
        .navigationSubtitle("Demonstrates multi-stage effects")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    FireworksView()
}
