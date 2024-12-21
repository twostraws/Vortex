//
// ConfettiView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating confetti bursts.
struct ConfettiView: View {
    var body: some View {
        VortexViewReader { proxy in
            ZStack {
                Text("Tap anywhere to create confetti.")

                VortexView(.confetti) {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 16, height: 16)
                        .tag("square")

                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
                .onTapGesture { location in
                    proxy.move(to: location)
                    proxy.burst()
                }
            }
        }
        .navigationSubtitle("Demonstrates on-demand particle bursting")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    ConfettiView()
}
