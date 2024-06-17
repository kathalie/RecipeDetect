//
//  SpacialObjectDetectionDelegate.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 16.06.2024.
//

import Foundation
import ARKit

public enum SpacialObjectDetectionState : Equatable {
    case startARSession
    case tapObject
    case boundObject
    case scan(progress: Int = 0)
    case info(arReferenceObject: ARReferenceObject?)
}

public protocol SpacialObjectDetectionDelegate {
    func nextState() -> SpacialObjectDetectionState
    func setState(newState: SpacialObjectDetectionState)
}
