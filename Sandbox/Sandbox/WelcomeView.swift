//
// WelcomeView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// An initial view to give an overview of the sandbox, plus links to more information.
struct WelcomeView: View {
    /// Tracks whether the user is currently hovering over the Hacking with Swift logo.
    @State private var logoHover = false

    var body: some View {
        VStack(spacing: 10) {
            Spacer()

            Image(.logo)
                .padding(.bottom, 10)

            Link("github.com/twostraws/vortex", destination: URL(string: "https://github.com/twostraws/vortex")!)
                .font(.title2.bold())

            Text("This is a small sandbox so you can see the various particle system presets in action.")
                .multilineTextAlignment(.center)
                .font(.title3)

            Spacer()
            Spacer()

            Link(destination: URL(string: "https://www.hackingwithswift.com")!) {
                VStack {
                    Image(.HWS)
                        .renderingMode(logoHover ? .template : .original)
                    Text("A Hacking with Swift Project")
                }
            }
            .onHover { logoHover = $0 }
            .foregroundStyle(.white)
        }
        .navigationSubtitle("Welcome to the Vortex Sandbox")
        .padding()
    }
}

#Preview {
    WelcomeView()
}
