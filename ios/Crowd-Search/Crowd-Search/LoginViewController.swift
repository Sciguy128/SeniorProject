import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure Firebase is configured
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("Missing Firebase Client ID")
        }
        
        // Configure Google Sign-In
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        
        // Add action for Google Sign-In
        signInButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        
        // Check if user is already signed in
        checkUserSignInStatus()
    }
    
    @objc func signInWithGoogle() {
        print("Google Sign-In button tapped")
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken else {
                print("Google sign-in did not return a user or ID token.")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in error: \(error.localizedDescription)")
                    return
                }
                
                print("Successfully signed in: \(authResult?.user.uid ?? "No user ID")")
                self.showHomeScreen()
            }
        }
    }
    
    func checkUserSignInStatus() {
        if Auth.auth().currentUser != nil {
            showHomeScreen()
        }
    }
    
    func showHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = homeVC
            window.makeKeyAndVisible()
        }
    }
}
