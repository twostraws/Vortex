//
// CampfireView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

#if !os(macOS)
import CoreMotion
import SwiftUI
import Vortex

/// A sample view demonstrating fire particles that blow in the direction of the device's rotation.
struct CampfireView: View {
    let motion: CMMotionManager
    let timer = Timer.publish(every: 1/120, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VortexViewReader { proxy in
            ZStack {
                Text("Rotate your device to change the direction of the fire.")

                VortexView(.campfire.makeUniqueCopy()) {
                    Circle()
                        .fill(.white)
                        .frame(width: 40)
                        .blur(radius: 4)
                        .blendMode(.plusLighter)
                        .tag("circle")
                }
                .updateGyroscope(for: motion, updateInterval: 1/120)
                .onReceive(timer) { _ in
                    if let data = motion.gyroData {
                        proxy.rotateBy(SIMD2(data.rotationRate.x, data.rotationRate.y))
                    }
                }
            }
        }
        .navigationSubtitle("Demonstrates the campfire preset with rotation")
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    CampfireView(motion: CMMotionManager())
}
#endif

