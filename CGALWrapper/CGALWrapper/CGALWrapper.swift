//
//  CGALWrapper.swift
//  CGALWrapper
//
//  Created by Kathryn Verkhogliad on 23.06.2024.
//

public class CGALWrapper {
    private let pointCloud: [SIMD3<Float>]
    
    public init(pointCloud: [SIMD3<Float>]) {
        self.pointCloud = pointCloud
    }
    
    public func volume() -> Float {
        let cgalPoints = pointCloud.map { point in
            CGALPoint(x: point.x, y: point.y, z: point.z)
        }
//        let volume = calculate_volume(cgalPoints, cgalPoints.count)
        
//        return volume
        return 0
    }
}

struct CGALPoint {
    let x: Float
    let y: Float
    let z: Float
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
