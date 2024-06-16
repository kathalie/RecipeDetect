/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Gesture interaction methods for the main view controller.
*/

import UIKit
import SceneKit

extension ViewController: UIGestureRecognizerDelegate {
    func setupGestureRecognisers() {
        sceneView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTap(_:)))
        )
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(didTap(_:)))
        )
        sceneView.addGestureRecognizer(ThresholdPanGestureRecognizer(
            target: self,
            action: #selector(didTwoFingerPan(_:)))
        )
        sceneView.addGestureRecognizer(ThresholdRotationGestureRecognizer(
            target: self,
            action: #selector(didRotate(_:)))
        )
        sceneView.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(didLongPress(_:)))
        )
        sceneView.addGestureRecognizer(ThresholdPinchGestureRecognizer(
            target: self,
            action: #selector(didPinch(_:)))
        )
    }
    
    @objc
    func didTap(_ gesture: UITapGestureRecognizer) {
        if state == .scanning {
            scan?.didTap(gesture)
            // add here recognition
        }
    }
    
    @objc
    func didOneFingerPan(_ gesture: UIPanGestureRecognizer) {
        if state == .scanning {
            scan?.didOneFingerPan(gesture)
        }
    }
    
    @objc
    func didTwoFingerPan(_ gesture: ThresholdPanGestureRecognizer) {
        if state == .scanning {
            scan?.didTwoFingerPan(gesture)
        }
    }
    
    @objc
    func didRotate(_ gesture: ThresholdRotationGestureRecognizer) {
        if state == .scanning {
            scan?.didRotate(gesture)
        }
    }
    
    @objc
    func didLongPress(_ gesture: UILongPressGestureRecognizer) {
        if state == .scanning {
            scan?.didLongPress(gesture)
        }
    }
    
    @objc
    func didPinch(_ gesture: ThresholdPinchGestureRecognizer) {
        if state == .scanning {
            scan?.didPinch(gesture)
        }
    }
    
    public func gestureRecognizer(_ first: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith second: UIGestureRecognizer) -> Bool {
        if first is UIRotationGestureRecognizer && second is UIPinchGestureRecognizer {
            return true
        } else if first is UIRotationGestureRecognizer && second is UIPanGestureRecognizer {
            return true
        } else if first is UIPinchGestureRecognizer && second is UIRotationGestureRecognizer {
            return true
        } else if first is UIPinchGestureRecognizer && second is UIPanGestureRecognizer {
            return true
        } else if first is UIPanGestureRecognizer && second is UIPinchGestureRecognizer {
            return true
        } else if first is UIPanGestureRecognizer && second is UIRotationGestureRecognizer {
            return true
        }
        return false
    }
}
