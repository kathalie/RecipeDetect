//
//  NextButton.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct NextButton<Destination: View>: View {
    let destination: Destination

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: destination) {
                    RoundedButton(content: Text("->"))
                }
            }
        }
        .padding(.trailing, 12)
        .padding(.bottom, 32)
    }
}

struct CornerButton_Previews: PreviewProvider {
    static var previews: some View {
        NextButton(destination: EmptyView())
    }
}
