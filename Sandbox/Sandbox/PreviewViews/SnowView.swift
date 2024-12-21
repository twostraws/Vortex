//
// SnowView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating the built-in snow preset.
struct SnowView: View {
    var body: some View {
        VortexView(.snow) {
            Circle()
                .fill(.white)
                .frame(width: 24)
                .blur(radius: 5)
                .tag("circle")
        }
        .navigationSubtitle("Demonstrates the snow preset")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    SnowView()
}
