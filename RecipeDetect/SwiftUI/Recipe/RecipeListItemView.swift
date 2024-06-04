//
//  RecipeListItemView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI
import Kingfisher

struct RecipeListItemView: View {
    @State private(set) var recipe: Recipe

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            KFImage(URL(string: recipe.image))
                .placeholder {
                    Image("large_placeholder")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.system(size: 22))
                    .bold()
                TimeText(time: recipe.time)
            }
            Spacer()
        }
        .padding(.vertical)
    }
}

struct RecipeListItemView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListItemView(
            recipe: .init(
                name: "apple pie",
                ingredients: [],
                time: "20 min",
                details: "details",
                image: "https://www.southernliving.com/thmb/fi3aPea-dRvahcmk42j0M-hoKc4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2589601_mailb_mailbox_apple_pie_003_0_0-2000-de5c23bb4c4e433fb6d5547d19cb3bcd-e219a711b4b94df792dcd2c8fd997d6a.jpg"))
    }
}
