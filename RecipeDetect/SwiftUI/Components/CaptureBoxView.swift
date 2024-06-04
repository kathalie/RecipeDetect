//
//  CaptureBoxView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct CaptureBoxView: View {
    private let box: CGRect
    private let width: CGFloat
    private let height: CGFloat
    private let x: CGFloat
    private let y: CGFloat
    private let topLeft: CGPoint
    private let topRight: CGPoint
    private let bottomLeft: CGPoint
    private let bottomRight: CGPoint

    init(box: CGRect) {
        self.box = box
        width = box.width
        height = box.height
        x = box.minX
        y = box.minY
        topLeft = CGPoint(x: x, y: y)
        topRight = CGPoint(x: x + width, y: y)
        bottomLeft = CGPoint(x: x, y: y + height)
        bottomRight = CGPoint(x: x + width, y: y + height)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.addRect(box)
            }
            .stroke(Color.green, lineWidth: 1)
            
            Path { path in
                let length = width / 8

                path.move(to: CGPoint(x: x, y: y + length))
                path.addLine(to: topLeft)
                path.addLine(to: CGPoint(x: x + length, y: y))
                
                path.move(to: CGPoint(x: x + width - length, y: y))
                path.addLine(to: topRight)
                path.addLine(to: CGPoint(x: x + width, y: y + length))
                
                path.move(to: CGPoint(x: x + width, y: y + width - length))
                path.addLine(to: bottomRight)
                path.addLine(to: CGPoint(x: x + width - length, y: y + width))
                
                path.move(to: CGPoint(x: x + length, y: y + width))
                path.addLine(to: bottomLeft)
                path.addLine(to: CGPoint(x: x, y: y + width - length))
            }
            .stroke(Color.green, lineWidth: 4)
        }
    }
}

struct CaptureBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CaptureBoxView(box: .init(x: 120, y: 300, width: 200, height: 200))
    }
}
