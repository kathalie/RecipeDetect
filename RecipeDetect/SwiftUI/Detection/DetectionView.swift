//
//  DetectionView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct DetectionView: View {
    let detections: [DistanceDetection]
    
    var body: some View {
        NavigationView {
            VStack {
                List(detections) { detection in
                    Text("\(detection.description)")
                }
                .listStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ARCameraView()) {
                    Image(systemName: "camera")
                }
            }
        }
        .addNextButton(destination: RecipeListView(queries: detections.map { ($0.label, $0.mass) }))
        .navigationTitle("Detection details")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DetectionView_Previews: PreviewProvider {
    static var previews: some View {
        DetectionView(
            detections: [
                .init(
                    label: "",
                    boundingBox: .init(x: 100, y: 40, width: 120, height: 150),
                    confidence: 1,
                    distance: 25,
                    radius: 4,
                    mass: 1),
            ])
    }
}
