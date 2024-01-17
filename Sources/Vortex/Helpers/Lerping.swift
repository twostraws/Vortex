//
// Lerping.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import Foundation

extension BinaryFloatingPoint {
     /// Performs a linear interpolation from one value to another by a weighting factor you specify
     /// - Parameter to: The value to interpolate towards
     /// - Parameter amount: The weighting factor, from 0 to 1.
     /// - Returns: The interpolated value
    func lerp(to value: Self, amount: Self) -> Self {
        self + (value - self) * amount
    }
}
