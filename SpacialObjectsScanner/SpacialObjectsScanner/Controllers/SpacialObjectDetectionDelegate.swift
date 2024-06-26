//
//  SpacialObjectDetectionDelegate.swift
//  SpacialObjectsScanner
//
//  Created by Kathryn Verkhogliad on 15.06.2024.
//

import Foundation
import ARKit

public enum SpacialObjectDetectionState {
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
