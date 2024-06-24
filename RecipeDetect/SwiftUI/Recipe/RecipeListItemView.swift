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
//            KFImage(URL(string: recipe.image))
//                .placeholder {
//                    Image("large_placeholder")
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                }
//                .cancelOnDisappear(true)
//                .resizable()
//                .frame(width: 100, height: 100)
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
                details: ["details"]))
    }
}
