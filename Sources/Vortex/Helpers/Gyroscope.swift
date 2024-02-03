//
// Gryoscope.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import CoreMotion
import SwiftUI

extension CMMotionManager {
    /// Starts gyroscope updates
    /// - Parameter updateInterval: The interval, in seconds, for providing gyroscope updates to the block handler.
    func startGyros(updateInterval: TimeInterval) {
        if self.isGyroAvailable {
            self.gyroUpdateInterval = updateInterval
            self.startGyroUpdates()
        }
    }
}

extension View {
    /// Starts gyroscope updates in onAppear and stops them in onDisappear
    /// - Parameters:
    ///   - motion: The `CMMotionManager` object for starting and managing motion services.
    ///   - updateInterval: The interval, in seconds, for providing gyroscope updates to the block handler.
    /// - Returns: A `View` that starts gyroscope updates for a given `CMMotionManager` gyroscope when it appears and stops updates
    /// when it disappears
    public func updateGyroscope(for motion: CMMotionManager, updateInterval: TimeInterval) -> some View {
        self
            .onAppear { motion.startGyros(updateInterval: updateInterval) }
            .onDisappear { motion.stopGyroUpdates() }
    }
}

