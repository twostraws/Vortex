//
// StarsView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import CoreMotion
import SwiftUI
import Vortex

/// A sample view demonstrating the built-in stars preset.
struct StarsView: View {
    let motion: CMMotionManager
    let timer = Timer.publish(every: 1/25, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VortexViewReader { proxy in
            VortexView(.stars.makeUniqueCopy()) {
                Circle()
                    .fill(.white)
                    .frame(width: 24)
                    .blur(radius: 3)
                    .tag("circle")
                    .blendMode(.plusLighter)
            }
            .navigationSubtitle("Demonstrates the stars preset")
            .ignoresSafeArea(edges: .top)
            .updateGyroscope(for: motion, updateInterval: 1/25)
            .onReceive(timer) { _ in
                if let data = motion.gyroData {
                    proxy.tiltBy(SIMD2(data.rotationRate.x, data.rotationRate.y))
                }
            }
        }
    }
}

#Preview {
    StarsView(motion: CMMotionManager())
}
