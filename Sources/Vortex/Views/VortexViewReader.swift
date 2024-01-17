//
// VortexViewReader.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// A view that wraps a `VortexView` in order to provide programmatic access to its particle system.
/// This creates a `VortexProxy` object and passes it into user space, so it can be used to adjust
/// attraction, create bursts, and more.
public struct VortexViewReader<Content: View>: View {
    /// The first vortex system contained by this reader.
    @State private var nearestVortexSystem: VortexSystem?

    /// The SwiftUI views inside this reader, which are given access to a proxy.
    let content: (VortexProxy) -> Content

    public init(@ViewBuilder content: @escaping (VortexProxy) -> Content) {
        self.content = content
    }

    public var body: some View {
        let proxy = VortexProxy(particleSystem: nearestVortexSystem) {
            nearestVortexSystem?.burst()
        } attractTo: { point in
            if let point {
                nearestVortexSystem?.attractionCenter = SIMD2(point.x, point.y)
            } else {
                nearestVortexSystem?.attractionCenter = nil
            }
        }

        /// Renders the views inside this reader, but also looks for Vortex systems inside.
        content(proxy)
            .onPreferenceChange(VortexSystemPreferenceKey.self) {
                nearestVortexSystem = $0
            }
    }
}
