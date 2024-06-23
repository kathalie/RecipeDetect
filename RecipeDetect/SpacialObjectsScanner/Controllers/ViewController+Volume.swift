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
                
                let meshNode = self.createMeshFromPointCloud(points: points)
                print(meshNode)
                
                self.sceneView.scene.rootNode.addChildNode(meshNode)
                
                var pointData = ""
                for point in points {
                    pointData.append("\(point.x) \(point.y) \(point.z)\n")
                }
                
                print(pointData)
            } else {
                let title = "Scan failed"
                let message = "Saving the scan failed."
                let buttonTitle = "Restart Scan"
                self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: false) { _ in
                    self.state = .startARSession
                }
            }
        }
    }
    
    func triangulatePointCloud(points: [SIMD3<Float>]) -> [SCNGeometryElement] {
        var indices: [Int32] = []

        for i in 0..<points.count {
            for j in (i+1)..<points.count {
                for k in (j+1)..<points.count {
                    indices.append(Int32(i))
                    indices.append(Int32(j))
                    indices.append(Int32(k))
                }
            }
        }
        
        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let element = SCNGeometryElement(data: indexData, primitiveType: .triangles, primitiveCount: indices.count / 3, bytesPerIndex: MemoryLayout<Int32>.size)
        
        return [element]
    }
    
    func createMeshFromPointCloud(points: [SIMD3<Float>]) -> SCNNode {
        let scnPoints = points.map { $0.toSCNVector3() }
        let vertexSource = SCNGeometrySource(vertices: scnPoints)
        
        let elements = triangulatePointCloud(points: points)
        
        let geometry = SCNGeometry(sources: [vertexSource], elements: elements)
        
        return SCNNode(geometry: geometry)
    }
}
