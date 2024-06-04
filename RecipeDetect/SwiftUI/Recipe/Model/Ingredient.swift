//
//  Ingredient.swift
//  ARScene
//
//  Created by Iryna Zubrytska.
//

import Foundation

struct Ingredient: Decodable, Equatable, Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let unit: String
    let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case name, unit, amount
    }
}
