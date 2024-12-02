//
// PlatformShims.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI


#if !os(macOS)
extension View {
    /// A tiny shim to make navigationSubtitle() do nothing everywhere
    /// except on macOS, where it actually works.
    func navigationSubtitle(_ text: String) -> some View {
        self
    }
}
#endif

