//
// FireView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
import Vortex

/// A sample view demonstrating fire particles that are attracted to the user's touch.
struct FireView: View {
    @State private var isDragging = false

    var body: some View {
        VortexViewReader { proxy in
            ZStack {
                if isDragging {
                    Text("Release your drag to reset the fire.")
                        .offset(y: 50)
                } else {
                    Text("Drag near the fire to attract it.")
                        .offset(y: 50)
                }

                VortexView(.fire.makeUniqueCopy()) {
                    Circle()
                        .fill(.white)
                        .frame(width: 32)
                        .blur(radius: 3)
                        .blendMode(.plusLighter)
                        .tag("circle")
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            proxy.attractTo(value.location)
                            proxy.particleSystem?.attractionStrength = 2
                            isDragging = true
                        }
                        .onEnded { _ in
                            proxy.particleSystem?.attractionStrength = 0
                            isDragging = false
                        }
                )
            }
        }
        .navigationSubtitle("Demonstrates the fire preset with attraction")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    FireView()
}
