//
//  View+Overlay.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

extension View {
    func drawCaptureBox(_ box: CGRect) -> some View {
        self.overlay(
            CaptureBoxView(box: box)
        )
    }

    func drawBoundingBoxes(_ boxes: [CGRect]) -> some View {
        self.overlay(
            ForEach(boxes, id: \.self) { box in
                BoundingBoxView(box: box)
            }
        )
    }
    
    func addNextButton(destination: some View) -> some View {
        self.overlay {
            NextButton(destination: destination)
        }
    }
}
