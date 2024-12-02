//
// FirefliesView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating fireflies that are repelled from the user's touch.
struct FirefliesView: View {
    @State private var isDragging = false

    var body: some View {
        VortexViewReader { proxy in
            ZStack(alignment: .bottom) {
                if isDragging {
                    Text("Release your drag to reset the fireflies.")
                        .padding(.bottom, 20)
                } else {
                    Text("Drag anywhere to repel the fireflies.")
                        .padding(.bottom, 20)
                }
                // Show the fireflies preset using default symbols
                VortexView(.fireflies)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            proxy.attractTo(value.location)
                            proxy.particleSystem?.attractionStrength = -2
                            isDragging = true
                        }
                        .onEnded { _ in
                            proxy.particleSystem?.attractionStrength = 0
                            isDragging = false
                        }
                )
            }
        }
        .navigationSubtitle("Demonstrates the fireflies preset with repulsion")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    FirefliesView()
}
