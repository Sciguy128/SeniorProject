//
//  UserManager.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
//

import Foundation
import Foundation
import FirebaseAuth

class UserManager {
    
    static let shared = UserManager()  // Singleton
    
    private init() {}
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var uid: String? {
        return currentUser?.uid
    }
    
    var email: String? {
        return currentUser?.email
    }
    
    var displayName: String? {
        return currentUser?.displayName
    }
    
    var photoURL: URL? {
        return currentUser?.photoURL
    }
    
    var isEmailVerified: Bool {
        return currentUser?.isEmailVerified ?? false
    }
    
    var phoneNumber: String? {
        return currentUser?.phoneNumber
    }

    func reloadUser(completion: @escaping (Error?) -> Void) {
        currentUser?.reload(completion: completion)
    }

    func printUserInfo() {
        guard let user = currentUser else {
            print("No user is signed in.")
            return
        }

        print("UID: \(user.uid)")
        print("Email: \(user.email ?? "No email")")
        print("Display Name: \(user.displayName ?? "No name")")
        print("Photo URL: \(user.photoURL?.absoluteString ?? "No photo")")
        print("Phone Number: \(user.phoneNumber ?? "No phone")")
        print("Email Verified: \(user.isEmailVerified)")
    }
}
