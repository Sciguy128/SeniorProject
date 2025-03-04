import UIKit
import Firebase
import FirebaseAuth 
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        checkUserSignInStatus()
        return true
    }
    
    // Handle Google Sign-In URL Redirect
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // Check user authentication status
    func checkUserSignInStatus() {
        if Auth.auth().currentUser != nil {
            showHomeScreen()
        } else {
            showLoginScreen()
        }
    }

    // Transition to Home Screen
    func showHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
    }

    // Transition to Login Screen
    func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
}
