/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Management of the UI steps for scanning an object in the main view controller.
*/

import Foundation
import ARKit
import SceneKit

extension SpacialObjectDetectionViewController {
    
    enum ARSessionState {
        case startARSession
        case notReady
        case scanning
    }
    
    /// - Tag: ARObjectScanningConfiguration
    // The current state the application is in
    var state: ARSessionState {
        get {
            return self.arSessionState
        }
        set {
            // 1. Check that preconditions for the state change are met.
            var newState = newValue
            switch newValue {
            case .startARSession:
                break
            case .notReady:
                // Immediately switch to .ready if tracking state is normal.
                if let camera = self.sceneView.session.currentFrame?.camera {
                    switch camera.trackingState {
                    case .normal:
                        newState = .scanning
                    default:
                        break
                    }
                } else {
                    newState = .startARSession
                }
            case .scanning:
                // Immediately switch to .notReady if tracking state is not normal.
                if let camera = self.sceneView.session.currentFrame?.camera {
                    switch camera.trackingState {
                    case .normal:
                        break
                    default:
                        newState = .notReady
                    }
                } else {
                    newState = .startARSession
                }
            }
            
            // 2. Apply changes as needed per state.
            arSessionState = newState
            
            switch newState {
            case .startARSession:
                print("State: Starting ARSession")
                scan = nil
                
                // Make sure the SCNScene is cleared of any SCNNodes from previous scans.
                sceneView.scene = SCNScene()
                
                let configuration = ARObjectScanningConfiguration()
                configuration.planeDetection = .horizontal
                sceneView.session.run(configuration, options: .resetTracking)
//                cancelMaxScanTimeTimer()
//                cancelMessageExpirationTimer()
            case .notReady:
                print("State: Not ready to scan")
                scan = nil
//                cancelMaxScanTimeTimer()
            case .scanning:
                print("State: Scanning")
                if scan == nil {
                    self.scan = Scan(sceneView)
                    self.scan?.state = .ready
                }
                
//                startMaxScanTimeTimer()
            }
        }
    }
}
