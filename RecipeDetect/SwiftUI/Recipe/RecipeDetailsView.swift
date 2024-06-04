//
//  RecipeDetailsView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI
import Kingfisher

struct RecipeDetailsView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack() {
            HStack {
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                Spacer()
            }
            KFImage(URL(string: recipe.image))
                .placeholder {
                    Image("small_placeholder")
                        .resizable()
                        .frame(width: 300, height: 300)
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: UIScreen.main.bounds.width)
                .scaledToFit()
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.title2)
                        .bold()
                    TimeText(time: recipe.time)
                    Spacer()
                        .frame(height: 8)
                    Text("Ingredients:")
                        .font(.title3)
                        .bold()
                    ForEach(recipe.ingredients) {
                        Text("\(String(format: "%.1f", $0.amount))\($0.unit) \($0.name)")
                    }
                    .listStyle(.plain)
                    .scrollDisabled(true)
                    Spacer()
                    Text("Details:")
                        .font(.title3)
                        .bold()
                    Text(recipe.details)
                }
                .padding(.horizontal)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ARCameraView()) {
                    Image(systemName: "camera")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsView(recipe: .init(
            name: "Apple pie",
            ingredients: [
                .init(name: "apple", unit: "g", amount: 400),
                .init(name: "flour", unit: "g", amount: 100),
                .init(name: "egg", unit: "", amount: 3),
            ],
            time: "45 min",
            details: "mix everything and bake 30 mins",
            image: "https://www.southernliving.com/thmb/fi3aPea-dRvahcmk42j0M-hoKc4=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2589601_mailb_mailbox_apple_pie_003_0_0-2000-de5c23bb4c4e433fb6d5547d19cb3bcd-e219a711b4b94df792dcd2c8fd997d6a.jpg"))
    }
}
