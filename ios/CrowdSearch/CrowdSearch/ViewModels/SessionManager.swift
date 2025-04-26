//
//  SessionManager.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
import Foundation
import FirebaseAuth
import Combine

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?

    init() {
        listenToAuthState()
    }

    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.currentUser = user
                self.isLoggedIn = user != nil
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        self.isLoggedIn = false
        self.currentUser = nil
    }
}
