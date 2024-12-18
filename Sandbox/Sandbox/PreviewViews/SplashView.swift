//
// SplashView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating how to overlap two particle views to create
/// more complex effects.
struct SplashView: View {
    var body: some View {
        ZStack {
            VortexView(.rain) {
                Circle()
                    .fill(.white)
                    .frame(width: 32)
                    .tag("circle")
            }

            VortexView(.splash) {
                Circle()
                    .fill(.white)
                    .frame(width: 16, height: 16)
                    .tag("circle")
            }
        }
        .navigationSubtitle("Demonstrates a combination rain/splash preset")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    SplashView()
}
