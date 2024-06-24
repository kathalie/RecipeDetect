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
                
                var pointData = ""
                for point in points {
                    pointData.append("\(point.x) \(point.y) \(point.z)\n")
                }
                
                print(pointData)
                
                //TODO calculate volume based on `pointData`
                let volume = 0.0
                
                guard let productName = self.productName else {
                    print("Something went wrong: product name is eventually nil.")
                    return
                }
                
                self.arSceneViewModel.product = Product(name: productName, volume: volume)
                
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
