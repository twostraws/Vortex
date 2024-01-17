//
// RandomSpread.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension Int {
    /// Creates a new random integer based on a range half above and half below
    /// the current value.
    func randomSpread() -> Int {
        Int.random(in: -self / 2...self / 2)
    }
}

extension Double {
    /// Creates a new random Double based on a range half above and half below
    /// the current value.
    func randomSpread() -> Double {
        Double.random(in: -self / 2...self / 2)
    }
}

extension SIMD3<Double> {
    /// Creates a new random `SIMD3<Double>` based on a range half above
    /// and half below the current value.
    func randomSpread() -> SIMD3<Double> {
        [
            Double.random(in: -x / 2...x / 2),
            Double.random(in: -y / 2...y / 2),
            Double.random(in: -z / 2...z / 2)
        ]
    }
}
