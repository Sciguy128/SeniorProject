//
//  HomeViewController.swift
//  Crowd-Search
//
//  Created by Ryan Lin on 3/2/25.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }

    @objc func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen()
        } catch let signOutError {
            print("Error signing out: \(signOutError)")
        }
    }

    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = loginVC
            window.makeKeyAndVisible()
        }
    }
}
