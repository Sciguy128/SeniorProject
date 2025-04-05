//
//  ContentView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
//
import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        Group {
            if session.isLoggedIn {
//                MapView()
                CrowdListView()
            } else {
                LoginView()
            }
        }
    }
}
