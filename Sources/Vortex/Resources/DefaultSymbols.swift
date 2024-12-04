//
// DefaultSymbols.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
/// Set up static variables for  images(symbols) in the asset catalog contained within the Resources folder
extension Image {
    public static let circle = Image("circle", bundle: Bundle.module)
    public static let confetti = Image("confetti", bundle: Bundle.module)
    public static let sparkle = Image("sparkle", bundle: Bundle.module)
}
