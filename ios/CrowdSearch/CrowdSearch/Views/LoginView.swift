// ios/CrowdSearch/Views/LoginView.swift
// Handles user authentication via Firebase.

import SwiftUI
import FirebaseAuth

/// Lets the user sign in or sign up with email/password and reports errors.
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
                if isSignUpMode { signUp() } else { signIn() }
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
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let e = error { errorMessage = e.localizedDescription }
            else { session.listenToAuthState() }
        }
    }

    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let e = error { errorMessage = e.localizedDescription }
            else { session.listenToAuthState() }
        }
    }
}

