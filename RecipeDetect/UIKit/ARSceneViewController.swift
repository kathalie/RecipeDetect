////
////  ARSceneViewController.swift
////  RecipeDetect
////
////  Created by Iryna Zubrytska.
////
//
//import UIKit
//import Anchorage
//import ARKit
//
//final class ARSceneViewController: UIViewController, ARSCNViewDelegate {
//    private enum Constants {
//        static let buttonSize: CGFloat = 64
//        static let bottomInset: CGFloat = 32
//        static let horizontalInset: CGFloat = 12
//    }
//    
//    private let sceneView: ARSCNView = ARSCNView()
//
//    private lazy var captureButton: UIButton = {
//        let button = UIButton(frame: .zero)
//        button.setPreferredSymbolConfiguration(.init(pointSize: Constants.buttonSize), forImageIn: .normal)
//        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//        button.tintColor = .white
//        button.layer.borderWidth = 4
//        button.layer.cornerRadius = Constants.buttonSize / 2
//        button.layer.masksToBounds = true
//        return button
//    }()
//
//    private lazy var clearButton: UIButton = {
//        let button = UIButton(frame: .init(x: 0, y: 0, width: Constants.buttonSize, height: Constants.buttonSize))
//        button.setTitle("Clear", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .white
//        button.layer.cornerRadius = Constants.buttonSize / 2
//        button.layer.shadowOffset = .init(width: 0, height: 0)
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowRadius = 5
//        button.layer.shadowOpacity = 0.3
//        return button
//    }()
//
//    let viewModel: ARSceneViewControllerViewModel
//    private var lidarSupported = false
//    
//    init(viewModel: ARSceneViewControllerViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: Lifecycle
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        if lidarSupported {
//            configuration.sceneReconstruction = .mesh
//        }
//        sceneView.session.run(configuration)
//        
//        clear()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if #available(iOS 13.4, *) {
//            lidarSupported = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
//        }
//
//        setupUI()
//        setupSceneView()
//        setupActions()
//        setupBindings()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        sceneView.session.pause()
//    }
//    
//    // MARK: UI
//    private func setupUI() {
//        view.addSubview(sceneView)
//        view.addSubview(captureButton)
//        view.addSubview(clearButton)
//        
//        sceneView.topAnchor == view.topAnchor
//        sceneView.leadingAnchor == view.leadingAnchor
//        sceneView.bottomAnchor == view.bottomAnchor
//        sceneView.trailingAnchor == view.trailingAnchor
//        
//        captureButton.centerXAnchor == view.centerXAnchor
//        captureButton.widthAnchor == Constants.buttonSize
//        captureButton.heightAnchor == Constants.buttonSize
//        captureButton.bottomAnchor == view.bottomAnchor - Constants.bottomInset
//
//        clearButton.leadingAnchor == view.leadingAnchor + Constants.horizontalInset
//        clearButton.bottomAnchor == view.bottomAnchor - Constants.bottomInset
//        clearButton.widthAnchor == Constants.buttonSize
//        clearButton.heightAnchor == Constants.buttonSize
//    }
//    
//    private func setupSceneView() {
//        sceneView.delegate = self
//        let scene = SCNScene()
//        sceneView.scene = scene
//        sceneView.autoenablesDefaultLighting = true
//    }
//    
//    private func setupActions() {
//        captureButton.addTarget(nil, action: #selector(capture), for: .touchUpInside)
//        clearButton.addTarget(nil, action: #selector(clear), for: .touchUpInside)
//    }
//    
//    // MARK: Actions
//    @objc private func capture() {
//        // clear previous results when taking new snapshot
//        sceneView.scene.rootNode.enumerateChildNodes({ (node,_)  in
//            node.removeFromParentNode()
//        })
//    
//        let snapshot = sceneView.snapshot()
//        viewModel.detect(snapshot: snapshot) {_,_ in 
//            
//        }
//    }
//
//    @objc private func clear() {
//        sceneView.scene.rootNode.enumerateChildNodes({ (node,_)  in
//            node.removeFromParentNode()
//        })
//    }
//    
//    // MARK: Bindings
//    private func setupBindings() {
//        viewModel.onDetectionSuccess = { [weak self] detections in
//            //TODO do it
//            //self?.handleDetections(detections)
//        }
//    }
//    
//    private func handleDetections(_ detections: [Detection]) {
//        let distanceDetections: [DistanceDetection] = detections.compactMap { detection in
//            if let distance = findDistance(to: detection),
//               let radius = findRadius(distance, detection.boundingBox)
//            {
//                return .init(
//                    label: detection.label,
//                    boundingBox: detection.boundingBox,
//                    confidence: detection.confidence,
//                    distance: distance,
//                    radius: radius,
//                    mass: Calculator.getMass(for: detection.label, radius: radius) ?? 0)
//            }
//            return nil
//        }
//        viewModel.handleDistanceDetections(distanceDetections, size: sceneView.bounds.size)
//    }
//    
//    // MARK: Calculations
//
//    /// Finds radius of detected object using camera's vertical field of view.
//    /// - Parameters:
//    ///    - distance: `Float` distance to object
//    ///    - box: `CGRect` object's bounding box
//    /// - Returns: `Float?` optional radius of object.
//    private func findRadius(_ distance: Float, _ box: CGRect) -> Float? {
//        guard let camera = sceneView.session.currentFrame?.camera else {
//            return nil
//        }
//        let imageResolution = camera.imageResolution
//        let viewSize = sceneView.bounds.size
//        let intrinsics = camera.intrinsics
//        let focalLength = intrinsics[0][0]
//        let xFovDegrees = atan(Float(imageResolution.width)/(2 * focalLength)) * 180/Float.pi
//        let fov = xFovDegrees * Float(viewSize.height / viewSize.width)
//        
//        let heightInPixels = box.height * viewSize.height
//        let widthInPixels = box.width * viewSize.width
//        let sideInPixels = (heightInPixels + widthInPixels) / 2
//        
//        let boxSide = sideInPixels / viewSize.height
//        let beta = fov * Float(boxSide) / 2
//        
//        let tg: Float = tan(beta * Float.pi / 180)
//        
//        let radius = distance * (sqrt(1 + pow(tg, 2)) + tg) * tg
//
//        return radius
//    }
//
//    /// Finds distance to detected object.
//    /// - Parameters:
//    ///    - detection: detection from `ObjectDetector`
//    /// - Returns: `Float?` distance to detection.
//    private func findDistance(to detection: Detection) -> Float? {
//        let centerCoordinate = center(of: detection.boundingBox)
//        if let distance = distance(to: centerCoordinate) {
//            return distance
//        }
//        return nil
//    }
//
//    ///  Converts detected bounding box center to point on sceneView
//    ///  - Parameters:
//    ///     - box: `CGRect` bounding box
//    ///  - Returns: `CGPoint` center point of bounding box on sceneView
//    private func center(of box: CGRect) -> CGPoint {
//        let imageWidth = sceneView.bounds.width
//        let imageHeight = sceneView.bounds.height
//        let x = box.midX * imageWidth
//        let y = box.midY * imageHeight
//
//        return CGPoint(x: x, y: y)
//    }
//    
//    /// Calculates distance to given point in centimeters
//    /// - Parameters:
//    ///    - box: `CGPoint` point to which distance will be measured
//    /// - Returns: `Float?` optional distance to the given point
//    private func distance(to point: CGPoint) -> Float? {
//        guard let query = sceneView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .any) else { return nil }
//        guard let raycastResult = sceneView.session.raycast(query).first else { return nil }
//
//        let destinationTransform : matrix_float4x4 = raycastResult.worldTransform
//        let destinationPosition: SIMD3<Float> =
//            .init(
//                destinationTransform.columns.3.x,
//                destinationTransform.columns.3.y,
//                destinationTransform.columns.3.z
//            )
//
//        guard let camera = sceneView.session.currentFrame?.camera else { return nil }
//        let cameraTransform : matrix_float4x4 = camera.transform
//        let cameraPosition: SIMD3<Float> =
//            .init(
//                cameraTransform.columns.3.x,
//                cameraTransform.columns.3.y,
//                cameraTransform.columns.3.z
//            )
//
//        let distance = simd_distance(cameraPosition, destinationPosition)
//        let distanceInCm = distance * 100
//
//        addDistanceNode(destinationTransform: destinationTransform, distance: distanceInCm)
//
//        return distanceInCm
//    }
//    
//    /// Adds node to sceneView
//    /// - Parameters:
//    ///    - destinationTransform: `matrix_float4x4` destination position to which node will be added
//    ///    - distance: `Float` text which represents distance and will be added to node
//    private func addDistanceNode(destinationTransform: matrix_float4x4, distance: Float) {
//        let destinationCoord: SCNVector3 = SCNVector3Make(
//            destinationTransform.columns.3.x,
//            destinationTransform.columns.3.y,
//            destinationTransform.columns.3.z
//        )
//    
//        let node: SCNNode = self.createDistanceNode("\(distance)")
//        self.sceneView.scene.rootNode.addChildNode(node)
//        node.position = destinationCoord
//    }
//    
//    private func createDistanceNode(_ distance : String) -> SCNNode {
//        let text = SCNText(string: distance, extrusionDepth: 0.5)
//        text.firstMaterial?.diffuse.contents = UIColor.green
//        text.firstMaterial?.specular.contents = UIColor.white
//        text.firstMaterial?.isDoubleSided = true
//
//        let titleNode = SCNNode(geometry: text)
//        titleNode.scale = SCNVector3(0.001, 0.001, 0.001)
//
//        let (minBound, maxBound) = text.boundingBox
//        titleNode.pivot = SCNMatrix4MakeTranslation(
//            (maxBound.x - minBound.x) / 2,
//            (maxBound.y - minBound.y) / 2,
//            0.01/2
//        )
//
//        let billboardConstraint = SCNBillboardConstraint()
//        billboardConstraint.freeAxes = SCNBillboardAxis.Y
//        titleNode.constraints = [billboardConstraint]
//        return titleNode
//    }
//}
