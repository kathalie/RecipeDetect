//
//  BoundingBoxView.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct BoundingBoxView: View {
    let box: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.addRect(box)
            }
            .stroke(Color.green, lineWidth: 1)
            .background {
                Circle()
                    .fill(Color.green)
                    .frame(width: 4, height: 4)
                    .position(CGPoint(x: box.midX, y: box.midY))
            }
        }
    }
}

struct BoundingBoxView_Previews: PreviewProvider {
    static var previews: some View {
        BoundingBoxView(box: .init(x: 20, y: 20, width: 100, height: 100))
    }
}
