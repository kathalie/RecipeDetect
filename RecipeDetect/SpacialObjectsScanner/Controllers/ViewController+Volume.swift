//
//  ViewController+TriangulatedMesh.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 23.06.2024.
//

import UIKit
import SceneKit

extension SIMD3 where Scalar == Float {
    func toSCNVector3() -> SCNVector3 {
        return SCNVector3(self.x, self.y, self.z)
    }
}

extension ViewController {
    func calculateVolume() {
        guard let scan = scan, scan.boundingBoxExists else {
            print("Error: Bounding box not yet created.")
            return
        }
        
        scan.createReferenceObject { scannedObject in
            if let object = scannedObject {
                let pointCloud = object.rawFeaturePoints
                let points = pointCloud.points
                
                fetchVolume(pointCloud: points) {data in
                    switch data {
                    case .success(let volumeData):
                        if let productName = self.productName {
                            let volumeValue: Double? = volumeData.volume
                            self.arSceneViewModel.product = Product(name: productName, volume: volumeValue)
                        } else {
                            print("Something went wrong: product name is eventually nil.")
                        }
                    case .failure:
                        print("error")
                        if let productName = self.productName {
                            DispatchQueue.main.async {
                                self.arSceneViewModel.product = Product(name: productName, volume: nil)
                            }
                        } else {
                            print("Something went wrong: product name is eventually nil.")
                        }
                    }
                }
                
                
            } else {
                let title = "Scan failed"
                let message = "Creating the scan failed. To calculate volume try again."
                let buttonTitle = "Restart Scan"
                
                self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: false) { _ in
                    self.state = .startARSession
                }
            }
        }
    }
}
