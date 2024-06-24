//
//  Recipe.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

struct Recipe: Decodable, Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let ingredients: [Ingredient]
    let time: String
    let details: [String]

    enum CodingKeys: String, CodingKey {
        case name, ingredients, time, details
    }
}
