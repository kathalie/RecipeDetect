/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Management of the UI steps for scanning an object in the main view controller.
*/

import Foundation
import ARKit
import SceneKit

extension SpacialObjectDetectionViewController {
    
    enum State {
        case startARSession
        case notReady
        case scanning
        case testing
    }
    
    /// - Tag: ARObjectScanningConfiguration
    // The current state the application is in
    var state: State {
        get {
            return self.internalState
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
            case .testing:
                guard scan?.boundingBoxExists == true else {
                    print("Error: Scan is not ready to be tested.")
                    return
                }
            }
            
            // 2. Apply changes as needed per state.
            internalState = newState
            
            switch newState {
            case .startARSession:
                print("State: Starting ARSession")
                scan = nil
                
                // Make sure the SCNScene is cleared of any SCNNodes from previous scans.
                sceneView.scene = SCNScene()
                
                let configuration = ARObjectScanningConfiguration()
                configuration.planeDetection = .horizontal
                sceneView.session.run(configuration, options: .resetTracking)
                cancelMaxScanTimeTimer()
                cancelMessageExpirationTimer()
            case .notReady:
                print("State: Not ready to scan")
                scan = nil
                cancelMaxScanTimeTimer()
            case .scanning:
                print("State: Scanning")
                if scan == nil {
                    self.scan = Scan(sceneView)
                    self.scan?.state = .ready
                }
                
                startMaxScanTimeTimer()
            case .testing:
                print("State: Testing")
//                self.setNavigationBarTitle("Test")
                cancelMaxScanTimeTimer()
            }
            
//            NotificationCenter.default.post(name: SpacialObjectDetectionViewController.appStateChangedNotification,
//                                            object: self,
//                                            userInfo: [SpacialObjectDetectionViewController.appStateUserInfoKey: self.state])
        }
    }
    
    @objc
    func scanningStateChanged(_ notification: Notification) {
        guard self.state == .scanning, let scan = notification.object as? Scan, scan === self.scan else { return }
        guard let scanState = notification.userInfo?[Scan.stateUserInfoKey] as? Scan.State else { return }
        
        DispatchQueue.main.async {
            switch scanState {
            case .ready:
                print("State: Ready to scan")
            case .defineBoundingBox:
                print("State: Define bounding box")
            case .scanning:
                self.sceneView.stopPlaneDetection()
            case .adjustingOrigin:
                print("State: Adjusting Origin")
            }
        }
    }
    
//    func switchToPreviousState() {
//        switch state {
//        case .startARSession:
//            break
//        case .notReady:
//            state = .startARSession
//        case .scanning:
//            if let scan = scan {
//                switch scan.state {
//                case .ready:
//                    restartButtonTapped(self)
//                case .defineBoundingBox:
//                    scan.state = .ready
//                case .scanning:
//                    scan.state = .defineBoundingBox
//                case .adjustingOrigin:
//                    scan.state = .scanning
//                }
//            }
//        case .testing:
//            state = .scanning
//            scan?.state = .adjustingOrigin
//        }
//    }
    
//    func switchToNextState() {
//        switch state {
//        case .startARSession:
//            state = .notReady
//        case .notReady:
//            state = .scanning
//        case .scanning:
//            if let scan = scan {
//                switch scan.state {
//                case .ready:
//                    scan.state = .defineBoundingBox
//                case .defineBoundingBox:
//                    scan.state = .scanning
//                case .scanning:
//                    scan.state = .adjustingOrigin
//                case .adjustingOrigin:
//                    state = .testing
//                }
//            }
//        case .testing:
//            // Testing is the last state, show the share sheet at the end.
////            createAndShareReferenceObject()
//            print("Testing")
//        }
//    }
}
