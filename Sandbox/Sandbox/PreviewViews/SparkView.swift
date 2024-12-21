//
// SparkView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating the built-in spark preset.
struct SparkView: View {
    var body: some View {
        VortexView(.spark) {
            Circle()
                .fill(.white)
                .frame(width: 16)
                .tag("circle")
        }
        .navigationSubtitle("Demonstrates the spark preset")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    SparkView()
}
