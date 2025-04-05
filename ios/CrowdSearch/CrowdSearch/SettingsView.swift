//
//  SettingsView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/31/25.
// 


import Foundation
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .font(.largeTitle)
                .bold()

            if let user = UserManager.shared.currentUser {
                VStack(alignment: .leading, spacing: 8) {
                    Text("UID: \(user.uid)")
                    Text("Email: \(user.email ?? "No email")")
                    Text("Display Name: \(user.displayName ?? "No name")")
                    Text("Phone: \(user.phoneNumber ?? "No phone")")
                    Text("Email Verified: \(user.isEmailVerified ? "Yes" : "No")")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No user is signed in.")
                    .foregroundColor(.red)
            }

            if isLoading {
                ProgressView()
            }

            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }

            Button("Reload User Info") {
                reloadUser()
            }
            .padding()

            Button("Logout") {
                logout()
            }
            .padding()
            .foregroundColor(.red)
        }
        .padding()
    }

    private func reloadUser() {
        isLoading = true
        errorMessage = nil

        UserManager.shared.reloadUser { error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            // Handle post-logout actions, like navigating to login screen
            print("Successfully logged out.")
        } catch {
            errorMessage = "Failed to log out: \(error.localizedDescription)"
        }
    }
}

#Preview{
    SettingsView()
}
