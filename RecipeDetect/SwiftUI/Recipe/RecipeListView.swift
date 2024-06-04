//
//  RecipeListView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct RecipeListView: View {
    @State var queries: [(String, Int)]
    @State private var recipes: [Recipe] = []

    var body: some View {
        VStack {
            if recipes.isEmpty {
                ProgressView()
            } else {
                List(recipes, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
                        RecipeListItemView(recipe: recipe)
                    }
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ARCameraView()) {
                    Image(systemName: "camera")
                }
            }
        }
        .navigationBarTitle("Recommendation list")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if SessionDataStore.hasRecipes {
                recipes = SessionDataStore.getRecipes(for: queries)
            } else {
                FirebaseService().getRecipes { recipes in
                    SessionDataStore.addRecipes(recipes)
                    self.recipes = SessionDataStore.getRecipes(for: queries)
                }
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView(queries: [("orange", 300)])
    }
}
