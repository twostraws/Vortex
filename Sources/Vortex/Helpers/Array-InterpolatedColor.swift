//
// Array-InterpolatedColor.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//
import SwiftUI

extension Array where Element == VortexSystem.Color {
    /// Creates a new color by linearly interpolating between other colors in a color array.
    /// - Parameter amount: How far through the array we should be reading. For example,
    /// if the array contains white then black and `amount` is set to 0.5, this will return gray.
    /// - Returns: A new color created by interpolating existing colors inside the array.
    func lerp(by amount: Double) -> VortexSystem.Color {
        guard isEmpty == false else {
            fatalError("Attempting to interpolate an empty color array.")
        }

        if amount <= 0 {
            return first!
        } else if amount >= 1 {
            return last!
        }

        let scaledPoint = amount * Double(count - 1)
        let lowerIndex = Int(scaledPoint)
        let upperIndex = lowerIndex + 1

        let lowerColor = self[lowerIndex]
        let upperColor = self[Swift.min(upperIndex, count - 1)]
        let interpolationFactor = scaledPoint - Double(lowerIndex)

        let interpolatedRed = lowerColor.red.lerp(to: upperColor.red, amount: interpolationFactor)
        let interpolatedGreen = lowerColor.green.lerp(to: upperColor.green, amount: interpolationFactor)
        let interpolatedBlue = lowerColor.blue.lerp(to: upperColor.blue, amount: interpolationFactor)
        let interpolatedOpacity = lowerColor.opacity.lerp(to: upperColor.opacity, amount: interpolationFactor)

        return VortexSystem.Color(
            red: interpolatedRed,
            green: interpolatedGreen,
            blue: interpolatedBlue,
            opacity: interpolatedOpacity
        )
    }
}
