//
//  CaptureFramePageView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct CaptureFramePageView: View {
    @Binding var showOnboarding: Bool

    var body: some View {
        VStack {
            Image("detection")
                .resizable()
                .scaledToFit()
            Text("Place objects inside frame")
                .font(.system(size: 24))
                .bold()
                .padding(.top, 24)
            Text("This will help to detect objects more precisely")
                .font(.system(size: 18))
                .padding(.vertical, 8)
                .multilineTextAlignment(.center)
            Button(action: {
                showOnboarding = false
            }) {
                RoundedButton(
                    content: Text("Got it"),
                    width: 140,
                    backgroundColor: .gray.opacity(0.3)
                )
            }
            .padding(.top, 32)
        }
        .padding()
    }
}

struct CaptureFramePageView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureFramePageView(showOnboarding: .constant(true))
    }
}
