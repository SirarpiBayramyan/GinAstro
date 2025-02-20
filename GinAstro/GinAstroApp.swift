//
//  GinAstroApp.swift
//  GinAstro
//
//  Created by Sirarpi Bayramyan on 15.02.25.
//#imageLiteral(resourceName: "ga.png")

import SwiftUI
import Firebase

@main
struct GinAstroApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            AuthView(viewModel: authViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure() // Initialize Firebase
        return true
    }
}
