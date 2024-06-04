//
//  MoveIphonePageView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct MoveIphonePageView: View {
    var body: some View  {
        VStack {
            Image("move1")
                .resizable()
                .scaledToFit()
            Image("move2")
                .resizable()
                .scaledToFit()
            Text("Move iPhone around the objects")
                .font(.system(size: 24))
                .bold()
                .padding(.top, 24)
            Text("This will help to learn the environment")
                .font(.system(size: 18))
                .padding(.vertical, 8)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct MoveIphonePageView_Previews: PreviewProvider {
    static var previews: some View {
        MoveIphonePageView()
    }
}
