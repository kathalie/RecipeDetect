//
//  Array+Ingredient.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

extension Array where Element == Ingredient {
    func get(name: String) -> Ingredient? {
        self.first { $0.name.lowercased() == name.lowercased() }
    }
}
