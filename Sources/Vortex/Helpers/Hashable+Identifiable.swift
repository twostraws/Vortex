//
// Hashable+Identifiable.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI
// Automatic conformance to Hashable for any Identifiable Type.
extension Hashable where Self: Identifiable {
    /// The default hash value for an Identifiable type is simply its identifier.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } 
}
