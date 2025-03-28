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
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Login") {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            .padding()
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            }
        }
        .padding()
    }
}
