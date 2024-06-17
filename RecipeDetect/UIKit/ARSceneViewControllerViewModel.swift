//
//  ARSceneViewControllerViewModel.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import UIKit

final class ARSceneViewControllerViewModel: ObservableObject {
//    enum State {
//        case initial
//        case data([DistanceDetection], UIImage, CGSize)
//        case error(AppError)
//    }
    enum State {
        case initial
        case data
        case error
    }
    var onDetectionSuccess: ((Classification) -> Void)?

    @Published private(set) var state: State = .initial
    @Published private(set) var classification: Classification? = nil

    private(set) var snapshot: UIImage?

    private let detector = ObjectDetector()
    
    func detect(snapshot: UIImage) {
        state = .initial
        self.snapshot = snapshot

        detector.classify(image: snapshot) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let classification):
                        self.onDetectionSuccess?(classification)
                        self.classification = classification
                        self.state = .data
                    
                        print("Detected: \(classification.label) with confidence: \(classification.confidence)")
                    case .failure(let error):
                        //self.state = .error(.detectionFailed)
                        self.state = .error
                    }
//                case let .success(detections):
//                    if detections.isEmpty {
//                        self.state = .error(.noDetectedObjects)
//                    } else {
//                        self.onDetectionSuccess?(detections)
//                    }
//                case .failure:
//                    self.state = .error(.detectionFailed)
//                }
            }
        }
    }
    
    func handleDistanceDetections(_ detections: [DistanceDetection], size: CGSize) {
        guard let snapshot else { return }
        if detections.isEmpty {
            state = .error
            //state = .error(.raycastFail)
        } else {
            //state = .data(detections, snapshot, size)
            state = .data
        }
    }
    
    func resetState() {
        state = .initial
    }
}
