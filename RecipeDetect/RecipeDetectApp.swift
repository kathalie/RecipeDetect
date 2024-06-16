//
//  RecipeDetectApp.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI
import Firebase

@main
struct RecipeDetectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
