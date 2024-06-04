//
//  Calculator.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

struct Calculator {
    private static let densities: [IngredientCase: Double] = [
        .apple: 0.808,
        .orange: 0.814
    ]
    
    // MARK: Public
    
    /// Returns mass for given detected ingredient in grams
    static func getMass(for label: String, radius: Float) -> Int? {
        guard let density = getDensity(for: label) else {
            return nil
        }
        
        let volume: Double = 4 / 3 * Double.pi * pow(Double(radius), 3)
        
        return Int(volume * density)
    }
    
    /// Merges amounts
    /// Example: [("apple", 300), ("apple", 400)] -> [("apple", 700)]
    static func mergeIngredients(_ amounts: [(String, Int)]) -> [String: Int] {
        var result: [String: Int] = [:]
        amounts.forEach { result[$0.0] = (result[$0.0] ?? 0) + $0.1 }
        return result
    }
    
    /// Recalculates recipes
    /// - Parameters:
    ///    - recipes: recipes to be recalculated
    ///    - amounts: amounts according to which recipes will be recalculated
    /// - Returns: `[Recipe]` recalculated recipes.
    static func recalculate(recipes: [Recipe], amounts: [String: Int]) -> [Recipe] {
        recipes.map { recalculate(recipe: $0, amounts: amounts) }
    }

    // MARK: Private

    /// Recalculates a recipe
    /// - Parameters:
    ///    - recipe: recipe to be recalculated
    ///    - amounts: amounts according to which recipe will be recalculated
    /// - Returns: `Recipe` recalculated recipe.
    private static func recalculate(recipe: Recipe, amounts: [String: Int]) -> Recipe {
        var proportions: [String: Double] = [:]
        amounts.forEach { key, value in
            if let ingredient = recipe.ingredients.get(name: key) {
                proportions[key] = Double(value) / Double(ingredient.amount)
            }
        }
        
        guard let min = proportions.values.min() else {
            return recipe
        }
        
        return Recipe(
            name: recipe.name,
            ingredients: recipe.ingredients.map {
                .init(name: $0.name, unit: $0.unit, amount: Double($0.amount) * min)
            },
            time: recipe.time,
            details: recipe.details,
            image: recipe.image)
    }

    /// Returns density for ingredient's name. Fails if such ingredient was not found in densities dictionary
    private static func getDensity(for ingredientName: String) -> Double? {
        if let ingredientCase = IngredientCase(rawValue: ingredientName.lowercased()) {
            return densities[ingredientCase]
        }
        return nil
    }
}
