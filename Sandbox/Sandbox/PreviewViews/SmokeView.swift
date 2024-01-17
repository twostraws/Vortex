//
// SmokeView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating the built-in smoke preset.
struct SmokeView: View {
    var body: some View {
        VortexView(.smoke.makeUniqueCopy()) {
            Circle()
                .fill(.white)
                .frame(width: 64)
                .blur(radius: 10)
                .tag("circle")
        }
        .navigationSubtitle("Demonstrates the smoke preset")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    SmokeView()
}
