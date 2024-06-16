/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the object scanning UI.
*/

import UIKit
import SceneKit
import ARKit
import Anchorage

public class SpacialObjectDetectionViewController: UIViewController {
    static var instance: SpacialObjectDetectionViewController?
    
    var lidarSupported = false
    
    var sceneView: ARSCNView = ARSCNView()
    
    var arSessionState: ARSessionState = .startARSession
    
    internal var scan: Scan?
//    internal var messageExpirationTimer: Timer?
//    internal var startTimeOfLastMessage: TimeInterval?
//    internal var expirationTimeOfLastMessage: TimeInterval?
    
    internal var screenCenter = CGPoint()
    
    var spacialObjectDetectionDelegate: SpacialObjectDetectionDelegate
//    var arSceneViewModel : ARSceneViewControllerViewModel
    
    init(spacialObjectDetectionDelegate: SpacialObjectDetectionDelegate
//         ,arSceneViewModel : ARSceneViewControllerViewModel
    ) {
        self.spacialObjectDetectionDelegate = spacialObjectDetectionDelegate
//        self.arSceneViewModel = arSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Application Lifecycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SpacialObjectDetectionViewController.instance = self
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.4, *) {
            lidarSupported = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        }
        
        // Prevent the screen from being dimmed after a while.
        UIApplication.shared.isIdleTimerDisabled = true
                
        displayWarningIfInLowPowerMode()
        
        // Make sure the application launches in .startARSession state.
        // Entering this state will run() the ARSession.
        state = .startARSession
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func setupUI() {
        view.addSubview(sceneView)
        
        sceneView.topAnchor == view.topAnchor
        sceneView.leadingAnchor == view.leadingAnchor
        sceneView.bottomAnchor == view.bottomAnchor
        sceneView.trailingAnchor == view.trailingAnchor
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupUI()
        setupSceneView()
        setupGestureRecognisers()
        screenCenter = sceneView.center
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
    
//    func capture() {
//        print("SpacialObjectDetectionViewController detecting ")
//        // clear previous results when taking new snapshot
//        sceneView.scene.rootNode.enumerateChildNodes({ (node,_)  in
//            node.removeFromParentNode()
//        })
//    
//        let snapshot = sceneView.snapshot()
//        arSceneViewModel.detect(snapshot: snapshot)
//        
//    }
    
//    var limitedTrackingTimer: Timer?
    
//    func startLimitedTrackingTimer() {
//        guard limitedTrackingTimer == nil else { return }
//        
//        limitedTrackingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
//            self.cancelLimitedTrackingTimer()
//            guard let scan = self.scan else { return }
//            if scan.state == .defineBoundingBox || scan.state == .scanning || scan.state == .adjustingOrigin {
//                let title = "Limited Tracking"
//                let message = "Low tracking quality - it is unlikely that a good reference object can be generated from this scan."
//                let buttonTitle = "Restart Scan"
//                
//                self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: true) { _ in
//                    self.state = .startARSession
//                }
//            }
//        }
//    }
//    
//    func cancelLimitedTrackingTimer() {
//        limitedTrackingTimer?.invalidate()
//        limitedTrackingTimer = nil
//    }
//    
//    var maxScanTimeTimer: Timer?
//    
//    func startMaxScanTimeTimer() {
//        guard maxScanTimeTimer == nil else { return }
//        
//        let timeout: TimeInterval = 60.0 * 5
//        
//        maxScanTimeTimer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { _ in
//            self.cancelMaxScanTimeTimer()
//            guard self.state == .scanning else { return }
//            let title = "Scan is taking too long"
//            let message = "Scanning consumes a lot of resources. This scan has been running for \(Int(timeout)) s. Consider closing the app and letting the device rest for a few minutes."
//            let buttonTitle = "OK"
//            self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: true)
//        }
//    }
//    
//    func cancelMaxScanTimeTimer() {
//        maxScanTimeTimer?.invalidate()
//        maxScanTimeTimer = nil
//    }
    

    
//    @objc
//    func boundingBoxPositionOrExtentChanged(_ notification: Notification) {
//        guard let box = notification.object as? BoundingBox,
//            let cameraPos = sceneView.pointOfView?.simdWorldPosition else { return }
//        
//        let xString = String(format: "width: %.2f", box.extent.x)
//        let yString = String(format: "height: %.2f", box.extent.y)
//        let zString = String(format: "length: %.2f", box.extent.z)
//        let distanceFromCamera = String(format: "%.2f m", distance(box.simdWorldPosition, cameraPos))
//    }
//    
//    @objc
//    func objectOriginPositionChanged(_ notification: Notification) {
//        guard let node = notification.object as? ObjectOrigin else { return }
//        
//        // Display origin position w.r.t. bounding box
//        let xString = String(format: "x: %.2f", node.position.x)
//        let yString = String(format: "y: %.2f", node.position.y)
//        let zString = String(format: "z: %.2f", node.position.z)
//        displayMessage("Current local origin position in meters:\n\(xString) \(yString) \(zString)", expirationTime: 1.5)
//    }
    
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
