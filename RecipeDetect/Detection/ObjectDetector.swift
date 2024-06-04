//
//  ObjectDetector.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import Foundation
import UIKit
import Vision

/// Class that is responsible for making request to ML model, processing the results and returning object detections
final class ObjectDetector {

    typealias DetectionResult = Result<[Detection], Error>
    private var completion: ((DetectionResult) -> Void)?

    private lazy var model: VNCoreMLModel = {
        let config = MLModelConfiguration()
        let baseModel = try! FruitDetector(configuration: config)
        return try! VNCoreMLModel(for: baseModel.model)
    }()

    private lazy var detectorRequest: VNImageBasedRequest = {
        let request = VNCoreMLRequest(model: model, completionHandler: requestCompletionHandler(_:error:))
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()

    func detect(image: UIImage, completion: @escaping ((DetectionResult) -> Void)) {
        self.completion = completion

        let handler = VNImageRequestHandler(
            cgImage: image.cgImage!,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )

        do {
            try handler.perform([detectorRequest])
        } catch {
            print(error)
        }
    }
    
    private func requestCompletionHandler(_ request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNRecognizedObjectObservation] else {
            return
        }
        completion?(.success(observations.sorted(by: { $0.confidence > $1.confidence }).compactMap { obs in
            if let label = obs.labels.first?.identifier {
                // model returns upside down results where origin is left bottom corner
                // so it's necessary to flip Y coordinate and height
                let flippedBox: CGRect = .init(
                    x: obs.boundingBox.origin.x,
                    y: 1 - obs.boundingBox.origin.y,
                    width: obs.boundingBox.width,
                    height: -obs.boundingBox.height)
                return Detection(label: label, boundingBox: flippedBox, confidence: obs.confidence)
            }
            else {
                return nil
            }
        }))
    }
}
