//
//  SessionManager.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
//

import Foundation
import FirebaseAuth
import Combine

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
