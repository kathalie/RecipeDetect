/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the object scanning UI.
*/

import UIKit
import Anchorage
import SceneKit
import ARKit

public class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIDocumentPickerDelegate {
    
    static let appStateChangedNotification = Notification.Name("ApplicationStateChanged")
    static let appStateUserInfoKey = "AppState"
    
    static var instance: ViewController?
    
    let sceneView = ARSCNView()
    var lidarSupported = false
    
//    @IBOutlet weak var sceneView: ARSCNView!
//    @IBOutlet weak var blurView: UIVisualEffectView!
//    @IBOutlet weak var nextButton: RoundedButton!
//    var backButton: UIBarButtonItem!
//    var mergeScanButton: UIBarButtonItem!
//    @IBOutlet weak var instructionView: UIVisualEffectView!
//    @IBOutlet weak var instructionLabel: MessageLabel!
//    @IBOutlet weak var loadModelButton: RoundedButton!
//    @IBOutlet weak var flashlightButton: FlashlightButton!
//    @IBOutlet weak var navigationBar: UINavigationBar!
//    @IBOutlet weak var sessionInfoView: UIVisualEffectView!
//    @IBOutlet weak var sessionInfoLabel: UILabel!
//    @IBOutlet weak var toggleInstructionsButton: RoundedButton!
    
    internal var internalState: State = .startARSession
    
    internal var scan: Scan?
    
    var referenceObjectToMerge: ARReferenceObject?
    var referenceObjectToTest: ARReferenceObject?
    
    internal var messageExpirationTimer: Timer?
    internal var startTimeOfLastMessage: TimeInterval?
    internal var expirationTimeOfLastMessage: TimeInterval?
    
    internal var screenCenter = CGPoint()
    //private let detector = ObjectDetector()


    var modelURL: URL? {
        didSet {
            if let url = modelURL {
                displayMessage("3D model \"\(url.lastPathComponent)\" received.", expirationTime: 3.0)
            }
            if let scannedObject = self.scan?.scannedObject {
                scannedObject.set3DModel(modelURL)
            }
        }
    }
    
//    var instructionsVisible: Bool = true {
//        didSet {
//            instructionView.isHidden = !instructionsVisible
//            toggleInstructionsButton.toggledOn = instructionsVisible
//        }
//    }
    
    // MARK: - Application Lifecycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewController.instance = self
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    private func setupUI() {
        view.addSubview(sceneView)
        
        sceneView.topAnchor == view.topAnchor
        sceneView.leadingAnchor == view.leadingAnchor
        sceneView.bottomAnchor == view.bottomAnchor
        sceneView.trailingAnchor == view.trailingAnchor
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.4, *) {
            lidarSupported = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        }
        
        setupUI()
        setupSceneView()
        
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true
        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(scanningStateChanged), name: Scan.stateChangedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(ghostBoundingBoxWasCreated),
//                                       name: ScannedObject.ghostBoundingBoxCreatedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(ghostBoundingBoxWasRemoved),
//                                       name: ScannedObject.ghostBoundingBoxRemovedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(boundingBoxWasCreated),
//                                       name: ScannedObject.boundingBoxCreatedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(scanPercentageChanged),
//                                       name: BoundingBox.scanPercentageChangedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(boundingBoxPositionOrExtentChanged(_:)),
//                                       name: BoundingBox.extentChangedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(boundingBoxPositionOrExtentChanged(_:)),
//                                       name: BoundingBox.positionChangedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(objectOriginPositionChanged(_:)),
//                                       name: ObjectOrigin.positionChangedNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(displayWarningIfInLowPowerMode),
//                                       name: Notification.Name.NSProcessInfoPowerStateDidChange, object: nil)
//        
//        setupNavigationBar()
        
        displayWarningIfInLowPowerMode()
        
        // Make sure the application launches in .startARSession state.
        // Entering this state will run() the ARSession.
        state = .startARSession
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Store the screen center location after the view's bounds did change,
        // so it can be retrieved later from outside the main thread.
        screenCenter = sceneView.center
    }
    
    // MARK: - UI Event Handling
    
    @IBAction func restartButtonTapped(_ sender: Any) {
        if let scan = scan, scan.boundingBoxExists {
            let title = "Start over?"
            let message = "Discard the current scan and start over?"
            self.showAlert(title: title, message: message, buttonTitle: "Yes", showCancel: true) { _ in
                self.state = .startARSession
            }
        } else {
            self.state = .startARSession
        }
    }
    
    func backFromBackground() {
        if state == .scanning {
            let title = "Warning: Scan may be broken"
            let message = "The scan was interrupted. It is recommended to restart the scan."
            let buttonTitle = "Restart Scan"
            self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: true) { _ in
                self.state = .notReady
            }
        }
    }
    
//    @IBAction func previousButtonTapped(_ sender: Any) {
//        switchToPreviousState()
//    }
//    
//    @IBAction func nextButtonTapped(_ sender: Any) {
//        guard !nextButton.isHidden && nextButton.isEnabled else { return }
//        switchToNextState()
//    }
    
    
//    @IBAction func leftButtonTouchAreaTapped(_ sender: Any) {
//        // A tap in the extended hit area on the lower left should cause a tap
//        //  on the button that is currently visible at that location.
//        if !loadModelButton.isHidden {
//            loadModelButtonTapped(self)
//        } else if !flashlightButton.isHidden {
//            toggleFlashlightButtonTapped(self)
//        }
//    }
    
//    @IBAction func toggleFlashlightButtonTapped(_ sender: Any) {
//        guard !flashlightButton.isHidden && flashlightButton.isEnabled else { return }
//        flashlightButton.toggledOn = !flashlightButton.toggledOn
//    }
    
//    @IBAction func toggleInstructionsButtonTapped(_ sender: Any) {
//        guard !toggleInstructionsButton.isHidden && toggleInstructionsButton.isEnabled else { return }
//        instructionsVisible.toggle()
//    }
    
//    func displayInstruction(_ message: Message) {
//        instructionLabel.display(message)
//        instructionsVisible = true
//    }
    
    
    func testObjectDetection() {
        // In case an object for testing has been received, use it right away...
        if let object = referenceObjectToTest {
            referenceObjectToTest = nil
            return
        }
        
        // ...otherwise attempt to create a reference object from the current scan.
        guard let scan = scan, scan.boundingBoxExists else {
            print("Error: Bounding box not yet created.")
            return
        }
        
        scan.createReferenceObject { scannedObject in
            if let object = scannedObject {
                return
            }
            
            let title = "Scan failed"
            let message = "Saving the scan failed."
            let buttonTitle = "Restart Scan"
            self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: false) { _ in
                self.state = .startARSession
            }
        }
    }
    
//    func createAndShareReferenceObject() {
//        guard let testRun = self.testRun, let object = testRun.referenceObject, let name = object.name else {
//            print("Error: Missing scanned object.")
//            return
//        }
//        
//        let documentURL = FileManager.default.temporaryDirectory.appendingPathComponent(name + ".arobject")
//        
//        DispatchQueue.global().async {
//            do {
//                try object.export(to: documentURL, previewImage: testRun.previewImage)
//            } catch {
//                fatalError("Failed to save the file to \(documentURL)")
//            }
//            
//            // Initiate a share sheet for the scanned object
//            let airdropShareSheet = ShareScanViewController(sourceView: self.nextButton, sharedObject: documentURL)
//            DispatchQueue.main.async {
//                self.present(airdropShareSheet, animated: true, completion: nil)
//            }
//        }
//    }
    
    var limitedTrackingTimer: Timer?
    
    func startLimitedTrackingTimer() {
        guard limitedTrackingTimer == nil else { return }
        
        limitedTrackingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.cancelLimitedTrackingTimer()
            guard let scan = self.scan else { return }
            if scan.state == .defineBoundingBox || scan.state == .scanning || scan.state == .adjustingOrigin {
                let title = "Limited Tracking"
                let message = "Low tracking quality - it is unlikely that a good reference object can be generated from this scan."
                let buttonTitle = "Restart Scan"
                
                self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: true) { _ in
                    self.state = .startARSession
                }
            }
        }
    }
    
    func cancelLimitedTrackingTimer() {
        limitedTrackingTimer?.invalidate()
        limitedTrackingTimer = nil
    }
    
    var maxScanTimeTimer: Timer?
    
    func startMaxScanTimeTimer() {
        guard maxScanTimeTimer == nil else { return }
        
        let timeout: TimeInterval = 60.0 * 5
        
        maxScanTimeTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
            self.cancelMaxScanTimeTimer()
            guard self.state == .scanning else { return }
            let title = "Scan is taking too long"
            let message = "Scanning consumes a lot of resources. This scan has been running for \(Int(timeout)) s. Consider closing the app and letting the device rest for a few minutes."
            let buttonTitle = "OK"
            self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: true)
        }
    }
    
    func cancelMaxScanTimeTimer() {
        maxScanTimeTimer?.invalidate()
        maxScanTimeTimer = nil
    }
    
    // MARK: - ARSessionDelegate
    
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        updateSessionInfoLabel(for: camera.trackingState)
        
        switch camera.trackingState {
        case .notAvailable:
            state = .notReady
        case .limited(let reason):
            switch state {
            case .startARSession:
                state = .notReady
            case .notReady, .testing:
                break
            case .scanning:
                if let scan = scan {
                    switch scan.state {
                    case .ready:
                        state = .notReady
                    case .defineBoundingBox, .scanning, .adjustingOrigin:
                        if reason == .relocalizing {
                            // If ARKit is relocalizing we should abort the current scan
                            // as this can cause unpredictable distortions of the map.
                            print("Warning: ARKit is relocalizing")
                            
                            let title = "Warning: Scan may be broken"
                            let message = "A gap in tracking has occurred. It is recommended to restart the scan."
                            let buttonTitle = "Restart Scan"
                            self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: true) { _ in
                                self.state = .notReady
                            }
                            
                        } else {
                            // Suggest the user to restart tracking after a while.
                            startLimitedTrackingTimer()
                        }
                    }
                }
            }
        case .normal:
            if limitedTrackingTimer != nil {
                cancelLimitedTrackingTimer()
            }
            
            switch state {
            case .startARSession, .notReady:
                state = .scanning
            case .scanning, .testing:
                break
            }
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let frame = sceneView.session.currentFrame else { return }
        scan?.updateOnEveryFrame(frame)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            return
        } 
        
        if state == .scanning, let planeAnchor = anchor as? ARPlaneAnchor {
            scan?.scannedObject.tryToAlignWithPlanes([planeAnchor])
            
            // After a plane was found, disable plane detection for performance reasons.
            sceneView.stopPlaneDetection()
        }
    }
    
    @objc
    func scanPercentageChanged(_ notification: Notification) {
        guard let percentage = notification.userInfo?[BoundingBox.scanPercentageUserInfoKey] as? Int else { return }
        
        // Switch to the next state if the scan is complete.
        if percentage >= 100 {
//            switchToNextState()
            return
        }
        DispatchQueue.main.async {
//            self.setNavigationBarTitle("Scan (\(percentage)%)")
        }
    }
    
    @objc
    func boundingBoxPositionOrExtentChanged(_ notification: Notification) {
        guard let box = notification.object as? BoundingBox,
            let cameraPos = sceneView.pointOfView?.simdWorldPosition else { return }
        
        let xString = String(format: "width: %.2f", box.extent.x)
        let yString = String(format: "height: %.2f", box.extent.y)
        let zString = String(format: "length: %.2f", box.extent.z)
        let distanceFromCamera = String(format: "%.2f m", distance(box.simdWorldPosition, cameraPos))
        displayMessage("Current bounding box: \(distanceFromCamera) away\n\(xString) \(yString) \(zString)", expirationTime: 1.5)
    }
    
    @objc
    func objectOriginPositionChanged(_ notification: Notification) {
        guard let node = notification.object as? ObjectOrigin else { return }
        
        // Display origin position w.r.t. bounding box
        let xString = String(format: "x: %.2f", node.position.x)
        let yString = String(format: "y: %.2f", node.position.y)
        let zString = String(format: "z: %.2f", node.position.z)
        displayMessage("Current local origin position in meters:\n\(xString) \(yString) \(zString)", expirationTime: 1.5)
    }
    
    @objc
    func displayWarningIfInLowPowerMode() {
        if ProcessInfo.processInfo.isLowPowerModeEnabled {
            let title = "Low Power Mode is enabled"
            let message = "Performance may be impacted. For best scanning results, disable Low Power Mode in Settings > Battery, and restart the scan."
            let buttonTitle = "OK"
            self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: false)
        }
    }
    
    public override var shouldAutorotate: Bool {
        // Lock UI rotation after starting a scan
        if let scan = scan, scan.state != .ready {
            return false
        }
        return true
    }
}
