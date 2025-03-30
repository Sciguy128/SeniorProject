//
//  LoginView.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var session: SessionManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isSignUpMode = false

    var body: some View {
        VStack(spacing: 16) {
            Text(isSignUpMode ? "Sign Up" : "Login")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(isSignUpMode ? "Create Account" : "Login") {
                if isSignUpMode {
                    signUp()
                } else {
                    signIn()
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)

            Button(isSignUpMode ? "Already have an account? Log in." : "Don't have an account? Sign up.") {
                isSignUpMode.toggle()
                errorMessage = ""
            }
            .font(.footnote)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                session.listenToAuthState() // Assuming SessionManager listens for auth changes
            }
        }
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                session.listenToAuthState()
            }
        }
    }
}
