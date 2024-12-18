//
// MagicView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating the built-in magic preset.
struct MagicView: View {
    var body: some View {
        VortexView(.magic) {
            Image(.sparkle)
                .blendMode(.plusLighter)
                .tag("sparkle")
        }
        .navigationSubtitle("Demonstrates the magic preset")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    MagicView()
}
