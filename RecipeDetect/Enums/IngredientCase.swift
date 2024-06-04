//
//  IngredientCase.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

enum IngredientCase: String, Equatable {
    case apple
    case orange
    
    var emoji: String {
        switch self {
        case .apple:
            return "🍎"
        case .orange:
            return "🍊"
        }
    }
}
