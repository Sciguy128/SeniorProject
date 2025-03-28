//
//  ContentView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        VStack {
            Text("Welcome to CrowdSearch!")
            Button("Sign Out") {
                session.signOut()
            }
        }
    }
}
