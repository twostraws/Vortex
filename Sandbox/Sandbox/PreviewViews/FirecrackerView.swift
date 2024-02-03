//
// FirecrackerView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import CoreMotion
import SwiftUI
import Vortex

/// A sample view demonstrating the built-in spark preset.
struct FirecrackerView: View {
    let motion: CMMotionManager
    let timer = Timer.publish(every: 1/25, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VortexViewReader { proxy in
            VortexView(.firecracker.makeUniqueCopy()) {
                Circle()
                    .fill(.white)
                    .frame(width: 16)
                    .tag("circle")
            }
            .navigationSubtitle("Demonstrates the spark preset")
            .ignoresSafeArea(edges: .top)
            .updateGyroscope(for: motion, updateInterval: 1/25)
            .onReceive(timer) { _ in
                if let data = motion.gyroData {
                    proxy.tiltBy(SIMD2(data.rotationRate.x, data.rotationRate.y))
                }
            }
        }
    }
    
    private func startGyros() {
        if motion.isGyroAvailable {
            motion.gyroUpdateInterval = 1.0 / 25.0
            motion.startGyroUpdates()
        }
    }
    
    
    private func stopGyros() {
        motion.stopGyroUpdates()
    }
}

#Preview {
    FirecrackerView(motion: CMMotionManager())
}
