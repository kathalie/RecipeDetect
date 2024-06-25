//
//  DistanceDetection.swift
//  ObjectRecognition
//
//  Created by Olesya Petrova on 16.06.2024.
//

import Foundation

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
Confidence: \(confidence * 100)%
Distance: \(distance.formatted()) cm
Radius: \(radius.formatted()) cm
Mass: \(mass) g
"""
    }
    
}
