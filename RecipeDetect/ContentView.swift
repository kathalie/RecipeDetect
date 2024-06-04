//
//  ContentView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "onboardingShown")

    var body: some View {
        ARCameraView()
            .sheet(isPresented: $showOnboarding) {
                OnboardingView(showOnboarding: $showOnboarding)
                    .onAppear {
                        UserDefaults.standard.set(true, forKey: "onboardingShown")
                    }
            }
    }
}
