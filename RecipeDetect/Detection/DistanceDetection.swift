//
//  DistanceDetection.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

/// Represents detection after being processed with full data
struct DistanceDetection: Identifiable, CustomStringConvertible {
    let id = UUID().uuidString
    let label: String
    let boundingBox: CGRect
    let confidence: Float
    let distance: Float
    let radius: Float
    let mass: Int
    
    var description: String {
"""
\(emoji) \(label.capitalized)
Confidence: \(confidence * 100)%
Distance: \(distance.formatted()) cm
Radius: \(radius.formatted()) cm
Mass: \(mass) g
"""
    }
    
    private var emoji: String {
        IngredientCase(rawValue: label.lowercased())?.emoji ?? ""
    }
}
