//
// VortexSystemPreferenceKey.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// Used by VortexViewReader to track the nearest particle system it contains.
struct VortexSystemPreferenceKey: PreferenceKey {
    static func reduce(value: inout VortexSystem?, nextValue: () -> VortexSystem?) { }
}
