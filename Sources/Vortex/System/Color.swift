//
// Color.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

extension VortexSystem {
    /// A Vortex color struct that gives easy access to its RGBA values, and is also `Codable`.
    public struct Color: Codable, ExpressibleByArrayLiteral, Hashable {
        public var red: Double
        public var green: Double
        public var blue: Double
        public var opacity: Double = 1

        /// Creates a new color from distinct RGBA values.
        public init(red: Double, green: Double, blue: Double, opacity: Double = 1) {
            self.red = red
            self.green = green
            self.blue = blue
            self.opacity = opacity
        }

        /// Creates a new color where the RGB values are all set to the same value.
        public init(white: Double, opacity: Double = 1) {
            self.red = white
            self.green = white
            self.blue = white
            self.opacity = opacity
        }

        /// Creates a color from 1 through 4 color values. Providing 1 color uses that for
        /// all RGB values, with 1 for opacity. Providing 2 colors uses the first for RGB,
        /// and the second for opacity. Providing 3 colors uses each one for R, G, then B,
        /// with 1 for opacity. Providing 4 colors uses each one for R, G, B, then opacity
        /// - Parameter elements: The color values to use for input.
        public init(arrayLiteral elements: Double...) {
            switch elements.count {
            case 1:
                self.init(white: elements[0])
            case 2:
                self.init(white: elements[0], opacity: elements[1])
            case 3:
                self.init(red: elements[0], green: elements[1], blue: elements[2])
            case 4:
                self.init(red: elements[0], green: elements[1], blue: elements[2], opacity: elements[3])
            default:
                fatalError("To create colors from an array you must provide 1 through 4 values.")
            }
        }

        /// A built-in black color.
        public static let black = Color(red: 0, green: 0, blue: 0, opacity: 1)

        /// An approximation of the default blue color in SwiftUI.
        public static let blue = Color(red: 0/255, green: 122/255, blue: 255/255, opacity: 1)

        /// An approximation of the default brown color in SwiftUI.
        public static let brown = Color(red: 78/255, green: 33/255, blue: 6/255, opacity: 1)

        /// A built-in color with zero opacity.
        public static let clear = Color(red: 0, green: 0, blue: 0, opacity: 0)

        /// An approximation of the default cyan color in SwiftUI.
        public static let cyan = Color(red: 50/255, green: 173/255, blue: 230/255, opacity: 1)

        /// A dark gray color with full opacity.
        public static let darkGray = Color(red: 64/255, green: 64/255, blue: 64/255, opacity: 1)

        /// A medium gray color with fully opacity.
        public static let gray = Color(red: 128/255, green: 128/255, blue: 128/255, opacity: 1)

        /// An approximation of the default green color in SwiftUI.
        public static let green = Color(red: 76/255, green: 217/255, blue: 100/255, opacity: 1)

        /// A light gray color with full opacity.
        public static let lightGray = Color(red: 192/255, green: 192/255, blue: 192/255, opacity: 1)

        /// An approximation of the default orange color in SwiftUI.
        public static let orange = Color(red: 255/255, green: 149/255, blue: 0/255, opacity: 1)

        /// An approximation of the default pink color in SwiftUI.
        public static let pink = Color(red: 255/255, green: 45/255, blue: 85/255, opacity: 1)

        /// An approximation of the default purple color in SwiftUI.
        public static let purple = Color(red: 88/255, green: 86/255, blue: 214/255, opacity: 1)

        /// An approximation of the default red color in SwiftUI.
        public static let red = Color(red: 255/255, green: 59/255, blue: 48/255, opacity: 1)

        /// An approximation of the default teal color in SwiftUI.
        public static let teal = Color(red: 90/255, green: 200/255, blue: 250/255, opacity: 1)

        /// A built-in white color.
        public static let white = Color(red: 1, green: 1, blue: 1, opacity: 1)

        /// An approximation of the default yellow color in SwiftUI.
        public static let yellow = Color(red: 255/255, green: 204/255, blue: 0/255, opacity: 1)

        /// Converts this Vortex color into its SwiftUI equivalent.
        var renderColor: SwiftUI.Color {
            SwiftUI.Color(red: red, green: green, blue: blue, opacity: opacity)
        }

        /// Multiplies the opacity of this color by the given amount.
        public func opacity(_ opacity: Double) -> Color {
            var copy = self
            copy.opacity = self.opacity * opacity
            return copy
        }
    }
}
