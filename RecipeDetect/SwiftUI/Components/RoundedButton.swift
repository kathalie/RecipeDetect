//
//  RoundedButton.swift
//  RecipeDetect
//
//  Created by Iryna Zubrytska.
//

import SwiftUI

struct RoundedButton<Content: View>: View {
    private let content: Content
    private let fontSize: CGFloat
    private let cornerRadius: CGFloat
    private let width: CGFloat?
    private let backgroundColor: Color
    
    init(
        content: Content,
        fontSize: CGFloat = 24,
        cornerRadius: CGFloat = 32,
        width: CGFloat? = nil,
        backgroundColor: Color = .white
    ) {
        self.content = content
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
        self.width = width
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        content
            .foregroundColor(.black)
            .font(.system(size: fontSize))
            .padding(cornerRadius / 2)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(radius: 4, y: 2)
                    .frame(width: width)
            )
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(content: Text("->"))
    }
}
