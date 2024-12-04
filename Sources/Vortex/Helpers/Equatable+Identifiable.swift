//
// Equatable+Identifiable.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//


// Automatic conformance to Equatable for any Identifiable Type.
extension Equatable where Self: Identifiable{
public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
