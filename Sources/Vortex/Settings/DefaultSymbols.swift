//
// DefaultSymbols.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
/// Load default images from the asset catalog in the Resources folder
extension Image {
    public static let circle = Image("circle", bundle: Bundle.module)
    public static let confetti = Image("confetti", bundle: Bundle.module)
    public static let sparkle = Image("sparkle", bundle: Bundle.module)
}
