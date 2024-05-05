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
        GeometryReader { geometry in
            VortexViewReader { proxy in
                ZStack {
                    Text("Tap anywhere to create confetti.")

                    VortexView(.confetti.makeUniqueCopy()) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .tag("square")

                        Circle()
                            .fill(Color.white)
                            .frame(width: 16)
                            .tag("circle")
                    }
                    .onTapGesture { location in
                        proxy.move(to: location) // works fine
                        proxy.burst()
                    }
                    .onAppear {
                        let initialPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        proxy.move(to: initialPosition) // should work now
                        proxy.burst()
                    }
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
