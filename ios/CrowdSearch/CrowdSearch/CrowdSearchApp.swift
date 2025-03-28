//
//  CrowdSearchApp.swift
//  CrowdSearch
//
//  Created by Ryan Lin on 3/28/25.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CrowdSearchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var session = SessionManager()

    var body: some Scene {
        WindowGroup {
            if session.isLoggedIn {
                ContentView()
                    .environmentObject(session)
            } else {
                LoginView()
                    .environmentObject(session)
            }
        }
    }
}

