// ios/CrowdSearch/Views/ContentView.swift
// Entry point that switches between login and main map.

import SwiftUI

/// Chooses between the login screen or the map based on authentication state.
struct ContentView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        Group {
            if session.isLoggedIn {
                MapView()
            } else {
                LoginView()
            }
        }
    }
}

