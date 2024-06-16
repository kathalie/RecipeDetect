//
//  ObjectDetector.swift
//  ObjectRecognition
//
//  Created by Olesya Petrova on 16.06.2024.
//

import Foundation
import UIKit
import Vision

final class ObjectDetector {

    typealias ClassificationResult = Result<Classification, Error>
    private var completion: ((ClassificationResult) -> Void)?

    private lazy var model: VNCoreMLModel = {
        let config = MLModelConfiguration()
        let baseModel = try! ProductsClassifier(configuration: config)
        return try! VNCoreMLModel(for: baseModel.model)
    }()

    private lazy var classificationRequest: VNCoreMLRequest = {
        let request = VNCoreMLRequest(model: model, completionHandler: requestCompletionHandler(_:error:))
        request.imageCropAndScaleOption = .centerCrop
        return request
    }()

    func classify(image: UIImage, completion: @escaping ((ClassificationResult) -> Void)) {
        self.completion = completion

        guard let cgImage = image.cgImage else {
            completion(.failure(ObjectDetectorError.invalidImage))
            return
        }

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation)
        )

        do {
            try handler.perform([classificationRequest])
        } catch {
            completion(.failure(error))
        }
    }

    private func requestCompletionHandler(_ request: VNRequest, error: Error?) {
        if let error = error {
            completion?(.failure(error))
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            completion?(.failure(ObjectDetectorError.noObservations))
            return
        }

        guard let topClassification = observations.max(by: { $0.confidence < $1.confidence }) else {
            completion?(.failure(ObjectDetectorError.noObservations))
            return
        }

        let classification = Classification(label: topClassification.identifier, confidence: topClassification.confidence)
        completion?(.success(classification))
    }
}


enum ObjectDetectorError: Error {
    case invalidImage
    case noObservations
}

struct Classification {
    let label: String
    let confidence: VNConfidence
}
