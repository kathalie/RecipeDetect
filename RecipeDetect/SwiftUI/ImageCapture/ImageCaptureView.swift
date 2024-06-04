//
//  ImageCaptureView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct ImageCaptureView: View {
    let detections: [DistanceDetection]
    let image: UIImage
    let size: CGSize

    var body: some View {
            ScrollView {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: size.width, height: size.height)
                        .drawBoundingBoxes(detections.map { adjustCoordinates($0.boundingBox) } )
                    Spacer()
                }
            }
            .navigationTitle("Bounding box")
            .navigationBarTitleDisplayMode(.large)
            .addNextButton(destination: DetectionView(detections: detections))
    }
    
    private func adjustCoordinates(_ rect: CGRect) -> CGRect {
        .init(
            x: rect.minX * size.width,
            y: rect.minY * size.height,
            width: rect.width * size.width,
            height: rect.height * size.height)
    }
}

struct ImageCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCaptureView(
            detections: [
                .init(
                    label: "",
                    boundingBox: .init(x: 100, y: 40, width: 120, height: 150),
                    confidence: 1,
                    distance: 25,
                    radius: 4,
                    mass: 1),
            ],
            image: .init(named: "fruit")!, size: .init(width: 390, height: 763))
    }
}
