//
//  SessionDataStore.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation
import SwiftUI

struct SessionDataStore {
    private static var recipes: [Recipe] = []

    static func addRecipes(_ recipes: [Recipe]) {
        self.recipes = recipes
    }

    static func getRecipes(for ingredients: [(String, Int)]) -> [Recipe] {
        let mergedIngredients = Calculator.mergeIngredients(ingredients)
    
        let filtered = recipes.filter { recipe in
            mergedIngredients.keys.allSatisfy { ingredient in
                recipe.ingredients.map { $0.name.lowercased() }.contains(ingredient.lowercased())
            }
        }

        return Calculator.recalculate(recipes: filtered, amounts: mergedIngredients)
    }
    
    static var hasRecipes: Bool {
        !recipes.isEmpty
    }
}
