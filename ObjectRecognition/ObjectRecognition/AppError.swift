//
//  AppError.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation

enum AppError: Error, CustomStringConvertible {
    case detectionFailed
    case noDetectedObjects
    case raycastFail
    
    var description: String {
        switch self {
        case .detectionFailed:
            return "Sorry, object detection failed.\nPlease, try again."
        case .noDetectedObjects:
            return "No objects were detected.\nPlease, try again."
        case .raycastFail:
            return "Sorry, distance could not be measured.\nPlease, move camera and try again."
        }
    }
}
