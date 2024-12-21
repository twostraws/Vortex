//
// RainView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating the built-in rain preset.
struct RainView: View {
    var body: some View {
        VortexView(.rain) {
            Circle()
                .fill(.white)
                .frame(width: 32)
                .tag("circle")
        }
        .navigationSubtitle("Demonstrates the rain preset")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    RainView()
}
