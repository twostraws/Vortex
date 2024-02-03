//
// StarsView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

#if !os(macOS)
import CoreMotion
import SwiftUI
import Vortex

/// A sample view demonstrating the built-in stars preset.
struct StarsView: View {
    let motion: CMMotionManager
    let timer = Timer.publish(every: 1/120, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VortexViewReader { proxy in
            ZStack {
                Text("Tilt your device to change the direction of the stars.")
                
                VortexView(.stars.makeUniqueCopy()) {
                    Circle()
                        .fill(.white)
                        .frame(width: 18)
                        .blur(radius: 3)
                        .tag("circle")
                        .blendMode(.plusLighter)
                    
                    Image(.sparkle)
                        .tag("sparkle")
                        .blendMode(.plusLighter)
                }
                .navigationSubtitle("Demonstrates the stars preset with tilt")
                .ignoresSafeArea(edges: .top)
                .updateGyroscope(for: motion, updateInterval: 1/120)
                .onReceive(timer) { _ in
                    if let data = motion.gyroData {
                        proxy.tiltBy(SIMD2(data.rotationRate.x, data.rotationRate.y))
                    }
                }
            }
        }
    }
}

#Preview {
    StarsView(motion: CMMotionManager())
}
#endif
