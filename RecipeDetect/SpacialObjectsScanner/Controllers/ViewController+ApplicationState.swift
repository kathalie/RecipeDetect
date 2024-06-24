/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Management of the UI steps for scanning an object in the main view controller.
*/

import Foundation
import ARKit
import SceneKit

extension ViewController {
    
    enum State {
        case startARSession
        case notReady
        case detecting
        case scanning
        case calculatingVolume
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
            case .detecting:
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
            case .calculatingVolume:
                guard scan?.boundingBoxExists == true else {
                    print("Error: Scan is not ready to calculate volume.")
                    return
                }
            }
            
            // 2. Apply changes as needed per state.
            internalState = newState
            
            switch newState {
            case .startARSession:
                print("State: Starting ARSession")
                scan = nil
                self.setNavigationBarTitle("")
                instructionsVisible = false
                showBackButton(false)
                nextButton.isHidden = true
                flashlightButton.isHidden = true
                
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
                self.setNavigationBarTitle("")
                flashlightButton.isHidden = true
                showBackButton(false)
                nextButton.isHidden = true
                displayInstruction(Message("Please wait for stable tracking"))
                cancelMaxScanTimeTimer()
            case .detecting:
                print("State: Detecting object")
                scan = nil
                self.setNavigationBarTitle("Detection")
                flashlightButton.isHidden = false
                showBackButton(false)
                nextButton.isHidden = false
                nextButton.setTitle("Detect", for: [])
                displayInstruction(Message("Point camera at the product you wish to detect"))
                cancelMaxScanTimeTimer()
            case .scanning:
                print("State: Scanning")
                flashlightButton.isHidden = false
                showBackButton(true)
                if scan == nil {
                    self.scan = Scan(sceneView)
                    self.scan?.state = .ready
                }
                startMaxScanTimeTimer()
            case .calculatingVolume:
                print("State: Calculating Volume")
                self.setNavigationBarTitle("Volume")
                calculateVolume()
                cancelMaxScanTimeTimer()
            }
            
            NotificationCenter.default.post(name: ViewController.appStateChangedNotification,
                                            object: self,
                                            userInfo: [ViewController.appStateUserInfoKey: self.state])
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
                self.setNavigationBarTitle("Ready to scan")
                self.showBackButton(false)
                self.nextButton.setTitle("Next", for: [])
                self.flashlightButton.isHidden = false
                if scan.ghostBoundingBoxExists {
                    self.displayInstruction(Message("Tap 'Next' to create an approximate bounding box around the object you want to scan."))
                    self.nextButton.isEnabled = true
                } else {
                    self.displayInstruction(Message("Point at a nearby object to scan."))
                    self.nextButton.isEnabled = false
                }
            case .defineBoundingBox:
                print("State: Define bounding box")
                self.displayInstruction(Message("Position and resize bounding box using gestures.\n" +
                    "Long press sides to push/pull them in or out. "))
                self.setNavigationBarTitle("Define bounding box")
                self.showBackButton(true)
                self.nextButton.isEnabled = scan.boundingBoxExists
                self.flashlightButton.isHidden = false
                self.nextButton.setTitle("Scan", for: [])
            case .scanning:
                self.displayInstruction(Message("Scan the object from all sides that you are " +
                    "interested in. Do not move the object while scanning!"))
                if let boundingBox = scan.scannedObject.boundingBox {
                    self.setNavigationBarTitle("Scan (\(boundingBox.progressPercentage)%)")
                } else {
                    self.setNavigationBarTitle("Scan 0%")
                }
                self.showBackButton(true)
                self.nextButton.isEnabled = true
                self.flashlightButton.isHidden = false
                self.nextButton.setTitle("Finish", for: [])
                
                // Disable plane detection (even if no plane has been found yet at this time) for performance reasons.
                self.sceneView.stopPlaneDetection()
                
            case .adjustingOrigin:
                print("State: Adjusting Origin")
                self.displayInstruction(Message("Adjust origin using gestures.\n" +
                    "You can load a *.usdz 3D model overlay."))
                self.setNavigationBarTitle("Adjust origin")
                self.showBackButton(true)
                self.nextButton.isEnabled = true
                self.flashlightButton.isHidden = false
                self.nextButton.setTitle("Volume", for: [])
            }
        }
    }
    
    func switchToPreviousState() {
        switch state {
        case .startARSession:
            break
        case .notReady:
            state = .startARSession
        case .detecting:
            state = .notReady
        case .scanning:
            if let scan = scan {
                switch scan.state {
                case .ready:
                    restartButtonTapped(self)
                case .defineBoundingBox:
                    scan.state = .ready
                case .scanning:
                    scan.state = .defineBoundingBox
                case .adjustingOrigin:
                    scan.state = .scanning
                }
            }
        case .calculatingVolume:
            state = .scanning
            scan?.state = .adjustingOrigin
        }
    }
    
    func switchToNextState() {
        switch state {
        case .startARSession:
            state = .notReady
        case .notReady:
            state = .detecting
        case .detecting:
            state = .scanning
        case .scanning:
            if let scan = scan {
                switch scan.state {
                case .ready:
                    scan.state = .defineBoundingBox
                case .defineBoundingBox:
                    scan.state = .scanning
                case .scanning:
                    scan.state = .adjustingOrigin
                case .adjustingOrigin:
                    state = .calculatingVolume
                }
            }
        case .calculatingVolume:
            calculateVolume()
        }
    }
    
    @objc
    func ghostBoundingBoxWasCreated(_ notification: Notification) {
        if let scan = scan, scan.state == .ready {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true
                self.displayInstruction(Message("Tap 'Next' to create an approximate bounding box around the object you want to scan."))
            }
        }
    }
    
    @objc
    func ghostBoundingBoxWasRemoved(_ notification: Notification) {
        if let scan = scan, scan.state == .ready {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = false
                self.displayInstruction(Message("Point at a nearby object to scan."))
            }
        }
    }
    
    @objc
    func boundingBoxWasCreated(_ notification: Notification) {
        if let scan = scan, scan.state == .defineBoundingBox {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true
            }
        }
    }
}
