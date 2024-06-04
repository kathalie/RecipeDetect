//
//  Detection.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import UIKit

/// Represents detection returned by `ObjectDetector`
struct Detection {
    let label: String
    let boundingBox: CGRect
    let confidence: Float
}
